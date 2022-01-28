	  var data1=[];
	  var words=[];
var chart;
var isDraw=false;
	  function showWordChart()
{
		  $('#container').html("");
var content;
	  $.ajax({
			type : 'GET',
			url : '/getTokensListForWordCloud',
			success : function(response) {
				content = response.result;
for(i=0;i<content.length;i++)
	{
	words[i]={};
	words[i].x=content[i].tokenName;
	words[i].value=content[i].frequencyCount;
	}
chart = anychart.tagCloud();
chart.data(words);
				 chart.title('Tokens Word Cloud');
				 chart.angles([0]);
				 chart.colorRange(true);
				 chart.colorRange().length('100%');
				 chart.container("container");
				 chart.draw();
				 chart.listen("pointClick", function(e){
				var url = e.point.get("x");
					});
			},
			error : function(error) {
				//$.notify("Error At Server side","error");
			}
		});	  
  isDraw=true;
}
