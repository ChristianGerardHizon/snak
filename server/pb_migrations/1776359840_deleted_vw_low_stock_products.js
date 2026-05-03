/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_1046633223");

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
        "autogeneratePattern": "",
        "hidden": false,
        "id": "_clone_nxxh",
        "max": 0,
        "min": 0,
        "name": "name",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "hidden": false,
        "id": "_clone_wllH",
        "max": null,
        "min": null,
        "name": "quantity",
        "onlyInt": false,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      },
      {
        "hidden": false,
        "id": "_clone_dDrg",
        "max": null,
        "min": null,
        "name": "stockThreshold",
        "onlyInt": false,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_2358601297",
        "hidden": false,
        "id": "_clone_BLwr",
        "maxSelect": 1,
        "minSelect": 0,
        "name": "branch",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      }
    ],
    "id": "pbc_1046633223",
    "indexes": [],
    "listRule": "",
    "name": "vw_low_stock_products",
    "system": false,
    "type": "view",
    "updateRule": null,
    "viewQuery": "SELECT\n  p.id,\n  p.name,\n  p.quantity,\n  p.stockThreshold,\n  p.branch\nFROM products p\nWHERE (p.isDeleted = false OR p.isDeleted IS NULL)\n  AND p.trackStock = true\n  AND p.trackByLot = false\n  AND p.stockThreshold > 0\n  AND p.quantity <= p.stockThreshold\n",
    "viewRule": ""
  });

  return app.save(collection);
})
