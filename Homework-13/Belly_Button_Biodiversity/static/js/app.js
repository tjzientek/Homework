function buildMetadata(sample) {

  // @TODO: Complete the following function that builds the metadata panel

  // Use `d3.json` to fetch the metadata for a sample
  d3.json("/metadata/" + sample).then(function(data) {

    // Use d3 to select the panel with id of `#sample-metadata`
    panel = d3.select("#sample-metadata");
    // Use `.html("") to clear any existing metadata
    panel.html("");
    // Use `Object.entries` to add each key and value pair to the panel
    // Hint: Inside the loop, you will need to use d3 to append new
    // tags for each key-value in the metadata.
    Object.entries(data).forEach(function([key, value]) {
      panel.append("p").html(key + ": " + value);
    });
  

    // BONUS: Build the Gauge Chart
    buildGauge(data.WFREQ);
  });
}

function buildGauge(data) {
    
  var level = data;

  // Trig to calc meter point
  var degrees = 9 - level, radius = .5;
  var radians = degrees * Math.PI / 9;
  var x = radius * Math.cos(radians);
  var y = radius * Math.sin(radians);

  // Path: may have to change to create a better triangle
  var mainPath = 'M -.0 -0.025 L .0 0.025 L ',
      pathX = String(x),
      space = ' ',
      pathY = String(y),
      pathEnd = ' Z';
  var path = mainPath.concat(pathX,space,pathY,pathEnd);

  var data = [{ type: 'scatter',
     x: [0], y:[0],
      marker: {size: 28, color:'850000'},
      showlegend: false,
      name: 'frequency',
      text: level,
      hoverinfo: 'text+name'},
    { values: [50/9, 50/9, 50/9, 50/9, 50/9, 50/9, 50/9, 50/9, 50/9, 50],
      rotation: 90,
      text: ['0-1', '1-2', '2-3', '3-4', '4-5', '5-6', '6-7', '7-8', '8-9'],
      textinfo: 'text',
      textposition:'inside',
      marker: {colors:['rgba(232, 226, 202, 1)', 'rgba(232, 226, 202, .75)',
        'rgba(232, 226, 202, .5)', 'rgba(210, 206, 145, .5)', 
        'rgba(202, 209, 95, .5)', 'rgba(170, 202, 42, .5)', 
        'rgba(110, 154, 22, .5)', 'rgba(14, 127, 0, .5)', 
        'rgba(14, 127, 0, .25)', 'rgba(255, 255, 255, 0)']},
      labels: ['0-1', '1-2', '2-3', '3-4', '4-5', '5-6', '6-7', '7-8', '8-9'],
      hoverinfo: 'label',
      hole: .5,
      type: 'pie',
      showlegend: false,
      direction: "clockwise"
  }];

  var layout = {
    shapes:[{
      type: 'path',
      path: path,
      fillcolor: '850000',
      line: {
        color: '850000'
      }
    }],
  title: 'Belly Button Washing Frequency<br>Scrubs per Week',
  titlefont: {size: (20)},
  xaxis: {zeroline:false, showticklabels:false,
             showgrid: false, range: [-1, 1]},
  yaxis: {zeroline:false, showticklabels:false,
             showgrid: false, range: [-1, 1]}
  };

Plotly.newPlot('gauge', data, layout);
  
}

function buildCharts(sample) {

  // @TODO: Use `d3.json` to fetch the sample data for the plots
  d3.json("/samples/" + sample).then(function(data) {
    // @TODO: Build a Bubble Chart using the sample data

    trace = [{x: data.otu_ids, y: data.sample_values, 
      mode: 'markers',
      marker: { size: data.sample_values, color: data.otu_ids },
      text: data.otu_labels
     }];

     Plotly.newPlot('bubble', trace);

    // @TODO: Build a Pie Chart
    // HINT: You will need to use slice() to grab the top 10 sample_values,
    // otu_ids, and labels (10 each).

    sample_values10 = data.sample_values.slice(0,10);
    otu_ids10 = data.otu_ids.slice(0,10);
    otu_labels10 = data.otu_labels.slice(0,10);
    trace1 = [{values: sample_values10,
    labels: otu_ids10,
    text: otu_labels10,
    textinfo: 'percent',
    type: 'pie' }];
    Plotly.newPlot('pie',trace1);
  });
}

function init() {
  // Grab a reference to the dropdown select element
  var selector = d3.select("#selDataset");

  // Use the list of sample names to populate the select options
  d3.json("/names").then((sampleNames) => {
    sampleNames.forEach((sample) => {
      selector
        .append("option")
        .text("BB_" + sample)
        .property("value", sample);
    });

    // Use the first sample from the list to build the initial plots
    const firstSample = sampleNames[0];
    buildCharts(firstSample);
    buildMetadata(firstSample);
  });
}

function optionChanged(newSample) {
  // Fetch new data each time a new sample is selected
  buildCharts(newSample);
  buildMetadata(newSample);
}

// Initialize the dashboard
init();
