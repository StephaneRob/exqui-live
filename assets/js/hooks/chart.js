import uPlot from 'uplot'

const buildUplotOptions = ({ name, element, now }) => {
  return {
    width: element.clientWidth,
    height: 300,
    series: [
      {},
      {
        label: 'Processed',
        spanGaps: true,
        width: 1,
        stroke: `#facc15ff`,
      },
      {
        label: 'Failed',
        spanGaps: true,
        width: 1,
        stroke: `#F87171`,
      },
    ],
    scales: {
      x: {
        min: now - 300,
        max: now,
      },
      y: {
        range: (self, min, max) => (max === 0 ? [0, 10] : [0, max]),
      },
    },
    axes: [
      {
        space: 40,
        values: [
          [3600 * 24 * 365, '{YYYY}', 7, '{YYYY}'],
          [3600 * 24 * 28, '{MMM}', 7, '{MMM}\n{YYYY}'],
          [3600 * 24, '{MM}-{DD}', 7, '{MM}-{DD}\n{YYYY}'],
          [3600, '{HH}:{mm}:{ss}', 4, '{HH}:{mm}:{ss}\n{YYYY}-{MM}-{DD}'],
          [60, '{HH}:{mm}', 4, '{HH}:{mm}:{ss}\n{YYYY}-{MM}-{DD}'],
          // [1, '{ss}', 2, '{HH}:{mm}:{ss}\n{YYYY}-{MM}-{DD}'],
        ],
      },
    ],
  }
}

class Chart {
  constructor(options) {
    const now = new Date().getTime() / 1000
    const { element } = options
    this.data = [[now], [0], [0]]
    this.uplotSettings = buildUplotOptions({ ...options, now })
    this.uplotChart = new uPlot(this.uplotSettings, this.data, element)
  }

  pushData(data) {
    data.forEach(({ timestamp, success, failed }) => {
      this.data[0].push(timestamp)
      this.data[1].push(success)
      this.data[2].push(failed)
    })

    const last = this.data[0][this.data[0].length - 1]
    this.uplotChart.setData(this.data)
    this.uplotChart.setScale('x', {
      min: last - 300,
      max: last,
    })
  }
}

export const ChartHook = {
  mounted() {
    const element = this.el.querySelector('.chart-container')
    const name = 'Stats'
    const options = { element, name }
    this.chart = new Chart(options)
  },
  updated() {
    const dataElements = this.el.querySelector('.data')

    const data = Array.from(dataElements.children || []).map(
      ({ dataset: { timestamp, success, failed } }) => {
        return {
          timestamp: parseFloat(timestamp),
          success: parseInt(success),
          failed: parseInt(failed),
        }
      }
    )

    if (data.length > 0) {
      this.chart.pushData(data)
    }
  },
}
