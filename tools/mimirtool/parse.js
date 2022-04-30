const fs = require("fs");

function parse(metrics) {
  let output = "";
  for (let i = 0; i < metrics.length; i++) {
    for (let k = 0; k < metrics[i].job_counts.length; k++) {
      if (metrics[i].job_counts[k].job != "integrations/nodejs") {
        output += metrics[i].metric;
        output += "|";
      }
    }
  }
  return output;
}

(function () {
  fs.readFile("./prometheus-metrics.json", (err, data) => {
    if (err) {
      console.log(`Error: ${err}`);
    } else {
      let unusedMetrics = JSON.parse(data).additional_metric_counts;
      output = parse(unusedMetrics);
      console.log(output);
    }
  });
})();
