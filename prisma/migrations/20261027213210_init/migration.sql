-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('REGULAR', 'ADMIN');

-- CreateEnum
CREATE TYPE "AuthMethod" AS ENUM ('CREDENTIALS', 'GOOGLE', 'YANDEX');

-- CreateEnum
CREATE TYPE "TokenType" AS ENUM ('VERIFICATION', 'TWO_FACTOR', 'PASSWORD_RESET');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('PENDING', 'PAID_AND_WAITING', 'PAID_AND_DELIVERING', 'DELIVERING', 'CANCELLED', 'COMPLETED');

-- CreateTable
CREATE TABLE "user" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT,
    "display_name" TEXT NOT NULL DEFAULT 'Не указано',
    "picture" TEXT NOT NULL DEFAULT 'https://yxozvv5vioi6ry47.public.blob.vercel-storage.com/icons/no-user-image.png',
    "role" "UserRole" NOT NULL DEFAULT 'REGULAR',
    "method" "AuthMethod" NOT NULL,
    "is_verified" BOOLEAN NOT NULL DEFAULT false,
    "is_two_factor_enabled" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "account" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "refresh_token" TEXT,
    "access_token" TEXT,
    "expires_at" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "user_id" TEXT NOT NULL,

    CONSTRAINT "account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "token" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "type" "TokenType" NOT NULL,
    "expires_in" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "token_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cart_item" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "user_id" TEXT NOT NULL,
    "variant_id" TEXT NOT NULL,

    CONSTRAINT "cart_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "status" "OrderStatus" NOT NULL DEFAULT 'PENDING',
    "total" DECIMAL(10,2) NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT,
    "phone" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "address" TEXT,
    "comment" TEXT,
    "payment_method_id" TEXT NOT NULL,
    "delivery_method_id" TEXT NOT NULL,
    "user_id" TEXT,

    CONSTRAINT "order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_item" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "quantity" INTEGER NOT NULL,
    "price_at_purchase" DECIMAL(10,2) NOT NULL,
    "order_id" TEXT,
    "variant_id" TEXT NOT NULL,

    CONSTRAINT "order_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "images" TEXT[],
    "category_id" TEXT,

    CONSTRAINT "product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_variant" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "sku" TEXT NOT NULL,
    "stock" INTEGER NOT NULL DEFAULT 0,
    "discount" INTEGER NOT NULL DEFAULT 0,
    "product_id" TEXT NOT NULL,

    CONSTRAINT "product_variant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "category" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "image" TEXT NOT NULL,

    CONSTRAINT "category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "promotion" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "title" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "image" TEXT NOT NULL,

    CONSTRAINT "promotion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "advertisement" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "title" TEXT NOT NULL,
    "image" TEXT NOT NULL,

    CONSTRAINT "advertisement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "review" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "text" TEXT NOT NULL,
    "rating" INTEGER NOT NULL,
    "user_id" TEXT NOT NULL,
    "product_id" TEXT NOT NULL,

    CONSTRAINT "review_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attribute" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "attribute_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "variant_property" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "value" TEXT NOT NULL,
    "variant_id" TEXT NOT NULL,
    "attribute_id" TEXT NOT NULL,

    CONSTRAINT "variant_property_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "delivery_method" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "isEnabled" BOOLEAN NOT NULL DEFAULT false,
    "instruction" TEXT,

    CONSTRAINT "delivery_method_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_method" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "isEnabled" BOOLEAN NOT NULL DEFAULT false,
    "instruction" TEXT,

    CONSTRAINT "payment_method_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_UserFavorites" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,

    CONSTRAINT "_UserFavorites_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "token_token_key" ON "token"("token");

-- CreateIndex
CREATE UNIQUE INDEX "cart_item_user_id_variant_id_key" ON "cart_item"("user_id", "variant_id");

-- CreateIndex
CREATE UNIQUE INDEX "product_variant_sku_key" ON "product_variant"("sku");

-- CreateIndex
CREATE UNIQUE INDEX "attribute_name_key" ON "attribute"("name");

-- CreateIndex
CREATE UNIQUE INDEX "variant_property_variant_id_attribute_id_key" ON "variant_property"("variant_id", "attribute_id");

-- CreateIndex
CREATE UNIQUE INDEX "delivery_method_code_key" ON "delivery_method"("code");

-- CreateIndex
CREATE UNIQUE INDEX "payment_method_code_key" ON "payment_method"("code");

-- CreateIndex
CREATE INDEX "_UserFavorites_B_index" ON "_UserFavorites"("B");

-- AddForeignKey
ALTER TABLE "account" ADD CONSTRAINT "account_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cart_item" ADD CONSTRAINT "cart_item_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cart_item" ADD CONSTRAINT "cart_item_variant_id_fkey" FOREIGN KEY ("variant_id") REFERENCES "product_variant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_payment_method_id_fkey" FOREIGN KEY ("payment_method_id") REFERENCES "payment_method"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_delivery_method_id_fkey" FOREIGN KEY ("delivery_method_id") REFERENCES "delivery_method"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_item" ADD CONSTRAINT "order_item_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "order"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_item" ADD CONSTRAINT "order_item_variant_id_fkey" FOREIGN KEY ("variant_id") REFERENCES "product_variant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product" ADD CONSTRAINT "product_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_variant" ADD CONSTRAINT "product_variant_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "review" ADD CONSTRAINT "review_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "review" ADD CONSTRAINT "review_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "variant_property" ADD CONSTRAINT "variant_property_variant_id_fkey" FOREIGN KEY ("variant_id") REFERENCES "product_variant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "variant_property" ADD CONSTRAINT "variant_property_attribute_id_fkey" FOREIGN KEY ("attribute_id") REFERENCES "attribute"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserFavorites" ADD CONSTRAINT "_UserFavorites_A_fkey" FOREIGN KEY ("A") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserFavorites" ADD CONSTRAINT "_UserFavorites_B_fkey" FOREIGN KEY ("B") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
