/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_1091709928")

  // add field
  collection.fields.addAt(3, new Field({
    "cascadeDelete": false,
    "collectionId": "pbc_1091709928",
    "hidden": false,
    "id": "relation4181388972",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "parentCategory",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "relation"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_1091709928")

  // remove field
  collection.fields.removeById("relation4181388972")

  return app.save(collection)
})
