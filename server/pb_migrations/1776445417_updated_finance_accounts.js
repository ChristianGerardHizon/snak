/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_99734836")

  // add field
  collection.fields.addAt(10, new Field({
    "hidden": false,
    "id": "bool2036001234",
    "name": "excludeFromTotal",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "bool"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_99734836")

  // remove field
  collection.fields.removeById("bool2036001234")

  return app.save(collection)
})
