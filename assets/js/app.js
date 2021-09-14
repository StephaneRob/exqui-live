import { Socket } from 'phoenix'
import { LiveSocket } from 'phoenix_live_view'

let socketPath = document.querySelector('html').getAttribute('phx-socket') || '/live'
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute('content')

const hooks = {}

let liveSocket = new LiveSocket(socketPath, Socket, {
  hooks: hooks,
  params: { _csrf_token: csrfToken },
})

liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
// >> window.liveSocket = liveSocket;
