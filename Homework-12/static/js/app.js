// from data.js
var tableData = data;

function loadData(data1) {

    DeleteRows();

    var tbody = d3.select("tbody");

    data1.forEach(function(sightings) {
        var row = tbody.append("tr");
        Object.entries(sightings).forEach(function([key, value]) {
            var cell = row.append("td");
            cell.text(value);
        });
    });
}

var submit = d3.select("#filter-btn");

submit.on("click", function() {

    // Prevent the page from refreshing
    d3.event.preventDefault();

    // Select the input element and get the raw HTML node
    var inputElement = d3.select("#datetime");

    // Get the value property of the input element
    var inputValue = inputElement.property("value");

    // Load the full dataset is not value from the imput field
    if (inputValue == null || inputValue == "") {
        loadData(tableData);
    } else {
        var filteredData = tableData.filter(tableData => tableData.datetime === inputValue);
        console.log("Got filtered data")
        loadData(filteredData);
    }
});

window.onload = function() {
    loadData(tableData);
};

function DeleteRows() {
    var rowCount = ufoTable.rows.length;
    for (var i = rowCount - 1; i > 0; i--) {
        ufoTable.deleteRow(i);
    }
}
