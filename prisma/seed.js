import { PrismaClient } from '@prisma/client'
import { glob } from 'glob'
import NodeID3 from 'node-id3'
import { realpathSync } from 'fs'
// import { fileURLToPath } from 'url'
// import { dirname, join } from 'path'

// const __filename = fileURLToPath(import.meta.url)
// const __dirname = dirname(__filename)
// const folderPath = join(__dirname, 'songs')
// console.log(folderPath)

const folderPath = realpathSync('./songs')
console.log(folderPath)

const prisma = new PrismaClient()

async function main() {
  let inserts = []
  const files = glob.sync(`${folderPath}/**/*.mp3`)
  await prisma.song.deleteMany({ where: { path: { notIn: files } } })

  for (const file of files) {
    const tags = NodeID3.read(file)

    const artistName = tags.artist || 'Unknown Artist'
    const songTitle = tags.title || 'Unknown Title'

    const existingSong = await prisma.song.findUnique({ where: { path: file } })

    if (!existingSong) {
      let existingArtist = await prisma.artist.findUnique({ where: { name: artistName } }) 
      // console.log(existingArtist)

      if (!existingArtist) existingArtist = await prisma.artist.create({ data: { name: artistName } })
 
      inserts.push(
        prisma.song.create({
          data: {
            artist: { connect: { id: existingArtist.id } },
            title: songTitle,
            path: file,
          },
        })
      )
    }
  }
  await prisma.$transaction(inserts)
}


main()
  .then(async () => {
    await prisma.$disconnect()
  })
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
  })
  .finally(async _ => {
    process.exitCode = 0
  })