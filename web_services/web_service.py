from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel
from fastapi import FastAPI

app = FastAPI()

# In-memory database simulation
invoices_db = []


class Item(BaseModel):
    description: str
    quantity: int
    price: float
    subtotal: float


class Invoice(BaseModel):
    business_name: str
    date: str
    items: List[Item]
    total: float


@app.post("/api/invoices")
async def save_invoice(invoice: Invoice):
    print(invoice)
    invoices_db.append(invoice.model_dump())
    return {"message": "Invoice saved successfully", "invoice": invoice.model_dump()}


@app.get("/api/invoices")
async def get_invoices():
    return {"invoices": invoices_db}