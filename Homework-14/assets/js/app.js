// @TODO: YOUR CODE HERE!

var w = 700;
var h = 500;
var padding = 40;


d3.csv("./assets/data/data.csv").then(function(data) {
       
    data.forEach(function(d) {
        d.poverty = +d.poverty;
        d.healthcare = +d.healthcare;
    });

    var xScale = d3.scaleLinear()
        .domain([8, d3.max(data, function(d) { return d.poverty; })  +2])
        .range([padding, w - padding * 2]);
    
    
    var yScale = d3.scaleLinear()
        .domain([0, d3.max(data, function(d) { return d.healthcare; })])
        .range([h - padding, padding]);

    var xAxis = d3.axisBottom().scale(xScale).ticks(7);
    var yAxis = d3.axisLeft().scale(yScale).ticks(10);


var svg = d3.select("#scatter")
    .append("svg")
    .attr("width", w)
    .attr("height", h);

    svg.selectAll("circle")
    .data(data)
    .enter()
    .append("circle")
    .classed("stateCircle", true)
    .attr("x", function(d) { return xScale(d.poverty); })
    .attr("y", function(d) { return yScale(d.healthcare); })
    .attr("cx", function(d) { return xScale(d.poverty); })
    .attr("cy", function(d) { return yScale(d.healthcare); })
    .attr("r", 8);

    svg.selectAll("text")
        .data(data)
        .enter()
        .append("text")
        .text(function(d) { return d.abbr; })
        .attr("x", function(d) { return xScale(d.poverty); })
        .attr("y", function(d) { return yScale(d.healthcare); })
        .classed("stateText", true)
        .attr("font-size", "8px")

    svg.append("g")
			.attr("class", "x axis")	
			.attr("transform", "translate(0," + (h - padding) + ")")
			.call(xAxis);
		
		//y axis
		svg.append("g")
			.attr("class", "y axis")	
			.attr("transform", "translate(" + padding + ", 0)")
			.call(yAxis);

});    

