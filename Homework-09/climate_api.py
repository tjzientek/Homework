import datetime as dt
import numpy as np
import pandas as pd

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

from flask import Flask, jsonify

#################################################
# Database Setup
#################################################
engine = create_engine("sqlite:///./Resources/hawaii.sqlite")

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save reference to the table
Measurement = Base.classes.measurement
Station = Base.classes.station

# Create our session (link) from Python to the DB
session = Session(engine)

#################################################
# Flask Setup
#################################################
app = Flask(__name__)


#################################################
# Flask Routes
#################################################

@app.route("/")
def welcome():
    return (
        f"Hawaii's Precipitation and Temperature Date<br/>"
        f"Available Routes:<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"/api/v1.0/stations<br/>"
        f"/api/v1.0/tobs<br/>"
        f"/api/v1.0/<start><br/>"
        f"/api/v1.0/<start>/<end><br/>"
    )

@app.route("/api/v1.0/precipitation")
def precipitation():
    
    max_date1 = session.query(func.max(Measurement.date)).filter(Measurement.station=="USC00519281").\
    group_by(Measurement.station).all()
    max_date = max_date1[0][0]

    date_12 = dt.datetime.strptime(max_date, '%Y-%m-%d') - dt.timedelta(days=365)
    min_date = date_12.strftime('%Y-%m-%d')

    tobs = session.query(Measurement.date, Measurement.tobs).filter(Measurement.date >= min_date).filter(Measurement.date <= max_date).all()
    dict_tobs = dict(tobs)
    if len(tobs) > 0:
        return jsonify(dict_tobs)

    return jsonify({"error": f"No precipitation data found."}), 404


@app.route("/api/v1.0/stations")
def stations():

    stations = session.query(Station).all()
    dict_stations = dict(stations)
    if (len(dict_stations) > 0):
        return jsonify(dict_stations)

    return jsonify({"error": f"No station data found."}), 404



if __name__ == "__main__":
    app.run(debug=True)