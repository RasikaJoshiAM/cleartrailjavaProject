<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<script src="https://cdn.anychart.com/releases/v8/js/anychart-base.min.js"></script>
  <script src="https://cdn.anychart.com/releases/v8/js/anychart-tag-cloud.min.js"></script>
  <jsp:include page='/MasterPageTopSectionNew' />
 <style>
      html, body, #container {
      width: 100%;
      height: 100%;
      margin: 0;
      padding: 0;
      }
    </style> 
    </head>
<body>
  <div id="container"> 
  <script>
  var words=[];
var data1=[];
  anychart.onDocumentReady(function() {
var content;
	  $.ajax({
			type : 'GET',
			url : '/getTokensListForChart',
			success : function(response) {
				content = response.result;
for(i=0;i<content.length;i++)
	{
	words[i]={};
	words[i].x=content[i].tokenName;
	words[i].value=content[i].frequencyCount;
	}
var chart = anychart.tagCloud();
chart.data(words,{
	"maxItems":20
});
				 chart.title('Tokens Word Cloud');
				 chart.angles([0])
				 // enable a color range
				 chart.colorRange(true);
				 // set the color range length
				 chart.colorRange().length('100%');
				 chart.container("container");
				 chart.draw();
				 chart.listen("pointClick", function(e){
				var url = e.point.get("x");
				alert(url);
					  
					});
			},
			error : function(error) {
				alert('It is an error');
			}
		});	  
});
    </script>
    </div>
    	<jsp:include page='/MasterPageBottomSection' />
</body>
</html>