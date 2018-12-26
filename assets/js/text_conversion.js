import {Socket} from "phoenix"

export default class TextConversion {
  constructor(properties) {
    this.convertedTextCallback = properties.convertedTextCallback
    // TODO: fix hardcoded URL
    this.socket          = new Socket("/til/socket")
    this.channel         = this.socket.channel("text_converter", {})
  }

  init() {
    this.socket.connect()
    this.channel.join()
    this.observeChannelResponse()
  }

  convert(text, format) {
    let conversionObject = {}
    conversionObject[format] = text
    this.channel.push("convert", conversionObject)
  }

  observeChannelResponse() {
    this.channel.on("converted", payload => {
      this.convertedTextCallback(payload.html);
    })
  }
}

