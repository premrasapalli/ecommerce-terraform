from fastapi import FastAPI
from .routes.products import router as products_router

app = FastAPI(
    title="E-Commerce API",
    version="1.0.0",
)

# health check (for ALB target group)
@app.get("/health")
def health():
    return {"status": "ok"}

# register routes
app.include_router(products_router, prefix="/products")

