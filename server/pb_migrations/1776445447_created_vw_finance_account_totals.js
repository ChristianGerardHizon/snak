/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
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
        "hidden": false,
        "id": "json926351894",
        "maxSize": 1,
        "name": "totalAssets",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      },
      {
        "hidden": false,
        "id": "json2375577209",
        "maxSize": 1,
        "name": "totalDebts",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      },
      {
        "hidden": false,
        "id": "json1382998775",
        "maxSize": 1,
        "name": "totalBalance",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      },
      {
        "hidden": false,
        "id": "number4278219676",
        "max": null,
        "min": null,
        "name": "includedAccounts",
        "onlyInt": true,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      }
    ],
    "id": "pbc_1523746115",
    "indexes": [],
    "listRule": "@request.auth.id != \"\"",
    "name": "vw_finance_account_totals",
    "system": false,
    "type": "view",
    "updateRule": null,
    "viewQuery": "SELECT 'totals' AS id, COALESCE(SUM(CASE WHEN accountType != 'debt' THEN openingBalance ELSE 0 END),0) AS totalAssets, COALESCE(SUM(CASE WHEN accountType = 'debt' THEN openingBalance ELSE 0 END),0) AS totalDebts, COALESCE(SUM(CASE WHEN accountType != 'debt' THEN openingBalance ELSE -openingBalance END),0) AS totalBalance, COUNT(*) AS includedAccounts FROM finance_accounts WHERE COALESCE(isArchived, false) = false AND COALESCE(excludeFromTotal, false) = false",
    "viewRule": "@request.auth.id != \"\""
  });

  return app.save(collection);
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_1523746115");

  return app.delete(collection);
})
