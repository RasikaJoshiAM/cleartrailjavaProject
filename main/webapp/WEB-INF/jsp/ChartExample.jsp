<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<script src="/canvasjs.min.js"></script>
<jsp:include page='/MasterPageTopSectionNew' />
<script>
var data1=[];
var chart;
window.onload = function() {
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
	}]
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
	}]
});
chart.render();
chart1.render();
		}
	});
}
</script>
</head>
<body>
<div class="row">
<div class="col-sm-6">
<div id="chartContainer" style="height: 500px; max-width: 620px; margin: 0px auto;"></div>
</div>
<div class="col-sm-6">
<div id="chartContainer1" style="height: 500px; max-width: 920px; margin: 0px auto;"></div>
</div>
</div>
<div class="row">
<div class="col-sm-6">
<div id="lineChartContainer1" style="height: 500px; max-width: 920px; margin: 0px auto;"></div>
</div>
</div>

	<jsp:include page='/MasterPageBottomSection' />
</body>
</html>