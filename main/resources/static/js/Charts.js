	
	var data1=[];
var chart;
function showCharts()
{
	$.ajax({
		type : 'GET',
		url : '/getTokensListForChart',
		success : function(response) {
			content = response.result;
for(i=0;i<content.length;i++)
{
data1[i]={};
data1[i].label=content[i].tokenName;
data1[i].y=content[i].frequencyCount;
}
chart = new CanvasJS.Chart("chartContainer", {
	theme: "light2", // "light1", "light2", "dark1", "dark2"
	exportEnabled: false,
	animationEnabled: false,
	title: {
		text: "Pie chart of Tokens"
	},
	data: [{
		type: "pie",
		startAngle: 25,
		toolTipContent: "<b>{label}</b>: ",
		showInLegend: "true",
		legendText: "{label}",
		indexLabelFontSize: 16,
		indexLabel: "{label} - {y}",
		dataPoints: data1,
		maxItems: 20
	}],
	height:500,
	width:620
});
var chart1 = new CanvasJS.Chart("chartContainer1", {
	animationEnabled: true,
	theme: "light2", // "light1", "light2", "dark1", "dark2"
	title:{
		text: "Column Chart of tokens"
	},
	axisY: {
		title: "Token Count"
	},
	data: [{        
		type: "column",  
		showInLegend: true, 
		legendMarkerColor: "grey",
		legendText: "Tokens",
		dataPoints: data1
	}],
	height:500,
	width:620
});
chart.render();
chart1.render();
		}
	},function(error){
		//$.notify("Error At Server side","error");
	});
}	
