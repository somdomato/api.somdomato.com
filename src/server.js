import Fastify from 'fastify'
import 'dotenv/config'
import routes from './routes/index.js'

const fastify = Fastify({ logger: true })

fastify.register(routes, { prefix: '/v1' })

fastify.get('/', async function handler (request, reply) {
  return { hello: 'world' }
})

fastify.listen({ port: process.env.PORT })