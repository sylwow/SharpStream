const NodeMediaServer = require('node-media-server');
const fetch = require('node-fetch'); // npm install node-fetch
const https = require('https');

const config = {
  rtmp: {
    port: 1935,
    chunk_size: 60000,
    gop_cache: true,
    ping: 30,
    ping_timeout: 60
  },
  http: {
    port: 8000,
    allow_origin: '*'
  },
  apiUrl: 'https://localhost:5001/Home/authenticate'
};

var nms = new NodeMediaServer(config)
nms.run();

// npm install node-fetch
nms.on('prePublish', async (id, StreamPath, args) => {
	debugger;
  try {
	const streamName = StreamPath.replace(/^\/live\//, '');
    const response = await authenticate(streamName, args.token);
	if (response.status !== 200)
		throw new Exception();
  } catch (error) {
	const session = nms.getSession(id);
	session.reject();
  }
});

function authenticate(streamName, token) {
	return fetch( `${config.apiUrl}/${streamName}`,
	{
		mode: 'no-cors',
		method: 'POST', 
		headers: {
			'Accept': 'application/json, text/plain',
			'Content-Type': 'application/json;charset=UTF-8'
		},
		body: JSON.stringify({
			token: token
		}),
		agent: new https.Agent({
			rejectUnauthorized: false,
		})
	});
}