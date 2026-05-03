/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_4080903852");

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
        "id": "_clone_zzoQ",
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
        "id": "_clone_NiGi",
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
        "id": "_clone_aiq6",
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
      }
    ],
    "id": "pbc_4080903852",
    "indexes": [],
    "listRule": "",
    "name": "vw_low_stock_lot_products",
    "system": false,
    "type": "view",
    "updateRule": null,
    "viewQuery": "SELECT\n  p.id,\n  p.name,\n  p.stockThreshold,\n  p.branch,\n  COALESCE(SUM(pl.quantity), 0) AS total_quantity\nFROM products p\nLEFT JOIN productLots pl ON p.id = pl.product AND (pl.isDeleted = false OR pl.isDeleted IS NULL)\nWHERE (p.isDeleted = false OR p.isDeleted IS NULL)\n  AND p.trackStock = true\n  AND p.trackByLot = true\n  AND p.stockThreshold > 0\nGROUP BY p.id, p.name, p.stockThreshold, p.branch\nHAVING total_quantity <= p.stockThreshold\n",
    "viewRule": ""
  });

  return app.save(collection);
})
