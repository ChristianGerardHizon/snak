/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_1157077295");

  return app.delete(collection);
}, (app) => {
  const collection = new Collection({
    "createRule": null,
    "deleteRule": null,
    "fields": [
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "text3208210256",
        "max": 0,
        "min": 0,
        "name": "id",
        "pattern": "^[a-z0-9]+$",
        "presentable": false,
        "primaryKey": true,
        "required": true,
        "system": true,
        "type": "text"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_2358601297",
        "hidden": false,
        "id": "_clone_Z4MR",
        "maxSelect": 1,
        "minSelect": 0,
        "name": "branch",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      },
      {
        "hidden": false,
        "id": "json554441351",
        "maxSize": 1,
        "name": "total_quantity",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      },
      {
        "hidden": false,
        "id": "number4086376812",
        "max": null,
        "min": null,
        "name": "lot_count",
        "onlyInt": true,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      },
      {
        "hidden": false,
        "id": "json2570954867",
        "maxSize": 1,
        "name": "earliest_expiration",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      },
      {
        "hidden": false,
        "id": "json806762343",
        "maxSize": 1,
        "name": "latest_expiration",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      }
    ],
    "id": "pbc_1157077295",
    "indexes": [],
    "listRule": "",
    "name": "vw_lot_quantity_totals",
    "system": false,
    "type": "view",
    "updateRule": null,
    "viewQuery": "SELECT\n  pl.product AS id,\n  p.branch,\n  SUM(pl.quantity) AS total_quantity,\n  COUNT(*) AS lot_count,\n  MIN(pl.expiration) AS earliest_expiration,\n  MAX(pl.expiration) AS latest_expiration\nFROM productLots pl\nJOIN products p ON pl.product = p.id\nWHERE (pl.isDeleted = false OR pl.isDeleted IS NULL)\nGROUP BY pl.product, p.branch",
    "viewRule": ""
  });

  return app.save(collection);
})
