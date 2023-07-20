export default function (fastify, opts, done) {
  fastify.get('/', (request, reply) => {
    reply.send({ message: 'Hello, user!' })
  })
  done()
}