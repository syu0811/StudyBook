import Chart from 'chart.js';
import Axios from './requests';
import CRC32 from 'crc-32';

function hashBytes(text) {
  let i32 = CRC32.str(text);

  let color = [
    (i32 & 0xFF000000) >>> 24,
    (i32 & 0x00FF0000) >>> 16,
    (i32 & 0x0000FF00) >>> 8,
    (i32 & 0x000000FF) >>> 0,
  ];
  return `rgba(${color.join(',')})`;
}

document.addEventListener('DOMContentLoaded', function () {
  let el = document.getElementById('notes_category_ratio_graph');
  if(el == null) return;

  const request_url =new URL(location).toString() + '/notes_category_ratio';

  Axios.get(request_url, {headers: {'X-Requested-With': 'XMLHttpRequest'}}).then(
    (response) => {
      new Chart(el, {
        type: 'doughnut',
        data: {
          labels: Object.keys(response.data),
          datasets: [{
            backgroundColor: Object.keys(response.data).map( label => hashBytes(label)),
            data: Object.values(response.data),
          }]
        },
        options: {
          layout: {
            padding: {
              left: 0,
              right: 0,
            }
          },
          legend: {
            display: true,
            position: 'bottom',
            labels: {
              boxWidth: 11,
              fontSize: 10,
            }
          },
        },
        responsive: false
      });
    }
  );
});
