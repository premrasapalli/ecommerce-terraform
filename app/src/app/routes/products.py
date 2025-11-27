from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.connection import get_db
from app.models.product import Product

router = APIRouter()

@router.get("/")
def list_products(db: Session = Depends(get_db)):
    products = db.query(Product).all()
    return {"products": [vars(p) for p in products]}

@router.get("/{product_id}")
def get_product(product_id: int, db: Session = Depends(get_db)):
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        return {"error": "Product not found"}
    return vars(product)

