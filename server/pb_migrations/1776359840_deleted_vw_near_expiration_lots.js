/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_3475837600");

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
        "collectionId": "pbc_4092854851",
        "hidden": false,
        "id": "relation1166304858",
        "maxSelect": 1,
        "minSelect": 0,
        "name": "product_id",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      },
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "_clone_TLNK",
        "max": 0,
        "min": 0,
        "name": "product_name",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "_clone_FIuQ",
        "max": 0,
        "min": 0,
        "name": "lotNumber",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "hidden": false,
        "id": "_clone_ErUx",
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
        "id": "_clone_7Lb9",
        "max": "",
        "min": "",
        "name": "expiration",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "date"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_2358601297",
        "hidden": false,
        "id": "_clone_eXXf",
        "maxSelect": 1,
        "minSelect": 0,
        "name": "branch",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      }
    ],
    "id": "pbc_3475837600",
    "indexes": [],
    "listRule": "",
    "name": "vw_near_expiration_lots",
    "system": false,
    "type": "view",
    "updateRule": null,
    "viewQuery": "SELECT\npl.id,\np.id AS product_id,\np.name AS product_name,\npl.lotNumber,\npl.quantity,\npl.expiration,\np.branch\nFROM productLots pl\nJOIN products p ON pl.product = p.id\nWHERE (pl.isDeleted = false OR pl.isDeleted IS NULL)\nAND (p.isDeleted = false OR p.isDeleted IS NULL)\nAND pl.expiration IS NOT NULL\nAND pl.expiration >= datetime('now')\nAND pl.expiration < datetime('now', '+30 days')\nAND p.trackStock = true\nORDER BY pl.expiration ASC\n",
    "viewRule": ""
  });

  return app.save(collection);
})
