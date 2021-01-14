import Chart from 'chart.js';

document.addEventListener('DOMContentLoaded', function () {
  let el = document.getElementById('user_study_graph');
  if(el == null) return;

  let labels = ['今月'];
  // 当月から過去12月分のラベル作成
  for(let i = 1; i <= 12; i++) {
    labels.push(i + '月前');
  }

  new Chart(el, {
    type: 'bar',
    data: {
      labels: labels.reverse(),
      datasets: [
        {
          label: '作業文字数',
          data: el.dataset.graph.split(','),
          borderColor: '#DC143C',
          backgroundColor: 'rgba(0,0,0,0)',
          type: 'line',
          yAxisID: 'line',
        },
        {
          label: '新規ノート数',
          data: el.dataset.createCountGraph.split(','),
          backgroundColor: '#93FFAB',
          yAxisID: 'bar',
        },
        {
          label: '更新ノート数',
          data: el.dataset.updateCountGraph.split(','),
          backgroundColor: '#C299FF',
          yAxisID: 'bar',
        }
      ]
    },
    options: {
      title: {
        display: true,
        text: '勉強履歴',
        fontSize: '24',
      },
      legend: {
        position: 'bottom',
      },
      scales: {
        yAxes: [{
          id: 'line',
          type: 'linear',
          position: 'left',
          ticks: {
            suggestedMax: 25000,
            max: 25000,
            suggestedMin: 0,
            stepSize: 5000,
            callback: function(value) {
              return value + '文字';
            }
          }
        },
        {
          id: 'bar',
          type: 'linear',
          position: 'right',
          ticks: {
            suggestedMax: 100,
            max: 100,
            suggestedMin: 0,
            stepSize: 20,
            callback: function(value) {
              return value + '枚';
            }
          },
          gridLines: {
            drawOnChartArea: false,
          },
        }
        ]
      }
    },
  });
});
