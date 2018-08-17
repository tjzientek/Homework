from flask import Flask, render_template, redirect

# Import our pymongo library, which lets us connect our Flask app to our Mongo database.
import pymongo

# Create an instance of our Flask app.
app = Flask(__name__)

# Create connection variable
conn = 'mongodb://localhost:27017'

# Pass connection to the pymongo instance.
client = pymongo.MongoClient(conn)

# Connect to a database. Will create one if not already available.
db = client.mars

# Set route
@app.route('/')
def index():
    # Load data from MondoDB
    data = list(db.data.find())[0]
    hemispheres = list(db.hemispheres.find())

    # Merge template with data
    return render_template('index.html', data=data, hemispheres=hemispheres)

@app.route('/scrape')
def scrape():
    # Load Scrape function
    from scrape_mars import scrape
    # Call Scrape function and save results to a dictionary
    dict1 = scrape()

    # Drop both database collections
    db.data.drop()
    db.hemispheres.drop()

    # Insert data into 'data' collection
    db.data.insert_one(
        {
            'news_title': dict1['news_title'],
            'news_desc': dict1['news_desc'],
            'featured_image_title': dict1['featured_image_title'],
            'featured_image_url': dict1['featured_image_url'],
            'mars_weather': dict1['mars_weather'],
            'mars_facts_table': dict1['mars_facts_table']
        }
    )

    # Insert data into 'hemispheres' collection
    for hemisphere in dict1['hemisphere_image_urls']:
        db.hemispheres.insert_one(
        { 
            'img_url': hemisphere['img_url'],
            'title': hemisphere['title']
         }
    )

    # return to the main route
    return redirect("/")


if __name__ == "__main__":
    app.run(debug=True)
