import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

let song = null

const pickRandom = async _ => {
  let songs = await prisma.song.findMany({ include: { artist: true } })
  
  if (songs.length === 0) { 
    songs = await prisma.song.findMany({ include: { artist: true } })
    if (songs.length === 0) return { song: [], songsCount: 0 } 
  }
  
  const randomIndex = Math.floor(Math.random() * songs.length)
  return songs[randomIndex]
}

const pedido = await prisma.request.findFirst({ include: { song: { include: { artist: true } } } })

if (pedido) {
  song = pedido.song
  await prisma.request.delete({ where: { id: pedido.id } })
} else {
  song = await pickRandom()
}

prisma.$disconnect()
process.stdout.write(song?.path || '')
process.exit()