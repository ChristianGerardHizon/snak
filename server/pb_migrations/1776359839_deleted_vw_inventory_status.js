/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_1671916814");

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
        "id": "_clone_GCCr",
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
        "id": "_clone_itKH",
        "name": "trackByLot",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "bool"
      },
      {
        "hidden": false,
        "id": "_clone_51ZT",
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
        "hidden": false,
        "id": "_clone_1qpV",
        "max": null,
        "min": 0,
        "name": "price",
        "onlyInt": false,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_3292755704",
        "hidden": false,
        "id": "_clone_VECS",
        "maxSelect": 1,
        "minSelect": 0,
        "name": "category",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_2358601297",
        "hidden": false,
        "id": "_clone_pjnO",
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
        "id": "_clone_MzzK",
        "max": "",
        "min": "",
        "name": "expiration",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "date"
      },
      {
        "hidden": false,
        "id": "_clone_pD8O",
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
        "id": "json146776509",
        "maxSize": 1,
        "name": "lot_total_quantity",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      },
      {
        "hidden": false,
        "id": "json4086376812",
        "maxSize": 1,
        "name": "lot_count",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      },
      {
        "hidden": false,
        "id": "json666199181",
        "maxSize": 1,
        "name": "expired_lots",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      },
      {
        "hidden": false,
        "id": "json2330606583",
        "maxSize": 1,
        "name": "near_expiration_lots",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
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
        "id": "_clone_HMkk",
        "name": "created",
        "onCreate": true,
        "onUpdate": false,
        "presentable": false,
        "system": false,
        "type": "autodate"
      },
      {
        "hidden": false,
        "id": "_clone_F0GB",
        "name": "updated",
        "onCreate": true,
        "onUpdate": true,
        "presentable": false,
        "system": false,
        "type": "autodate"
      }
    ],
    "id": "pbc_1671916814",
    "indexes": [],
    "listRule": "",
    "name": "vw_inventory_status",
    "system": false,
    "type": "view",
    "updateRule": null,
    "viewQuery": "SELECT\n  p.id,\n  p.name,\n  p.trackByLot,\n  p.stockThreshold,\n  p.price,\n  p.category,\n  p.branch,\n  p.expiration,\n  p.quantity,\n  COALESCE(lot_totals.total_quantity, 0) AS lot_total_quantity,\n  COALESCE(lot_totals.lot_count, 0) AS lot_count,\n  COALESCE(lot_totals.expired_lots, 0) AS expired_lots,\n  COALESCE(lot_totals.near_expiration_lots, 0) AS near_expiration_lots,\n  lot_totals.earliest_expiration,\n  p.created,\n  p.updated\nFROM products p\nLEFT JOIN (\n  SELECT\n    pl.product,\n    SUM(pl.quantity) AS total_quantity,\n    COUNT(*) AS lot_count,\n    MIN(pl.expiration) AS earliest_expiration,\n    SUM(pl.expiration < datetime('now')) AS expired_lots,\n    SUM(pl.expiration >= datetime('now') AND pl.expiration < datetime('now', '+30 days')) AS near_expiration_lots\n  FROM productLots pl\n  WHERE pl.isDeleted = false OR pl.isDeleted IS NULL\n  GROUP BY pl.product\n) lot_totals ON p.id = lot_totals.product\nWHERE (p.isDeleted = false OR p.isDeleted IS NULL)\n  AND p.trackStock = true\n",
    "viewRule": ""
  });

  return app.save(collection);
})
