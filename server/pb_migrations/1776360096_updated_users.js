/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_3841632486")

  // remove field
  collection.fields.removeById("relation3146128159")

  // remove field
  collection.fields.removeById("relation1466534506")

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_3841632486")

  // add field
  collection.fields.addAt(9, new Field({
    "cascadeDelete": false,
    "collectionId": "pbc_2358601297",
    "hidden": false,
    "id": "relation3146128159",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "branch",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "relation"
  }))

  // add field
  collection.fields.addAt(10, new Field({
    "cascadeDelete": false,
    "collectionId": "pbc_2105053228",
    "hidden": false,
    "id": "relation1466534506",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "role",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "relation"
  }))

  return app.save(collection)
})
