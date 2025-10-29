# Women's E-Commerce App Architecture

## MVP Features
1. **Home Page** - Featured products, categories, search
2. **Product Catalog** - Grid view with filtering/sorting
3. **Product Details** - Images, description, sizes, add to cart
4. **Cart** - View items, update quantities, checkout
5. **Wishlist** - Save favorite products
6. **Profile** - User info, orders, settings
7. **Categories** - Browse by category
8. **Search** - Find products

## Data Models (`lib/models/`)
- `user.dart` - User profile data
- `product.dart` - Product information
- `cart_item.dart` - Cart item with quantity
- `order.dart` - Order history
- `category.dart` - Product categories

## Services (`lib/services/`)
- `user_service.dart` - User data operations with local storage
- `product_service.dart` - Product CRUD with sample data in local storage
- `cart_service.dart` - Cart management in local storage
- `wishlist_service.dart` - Wishlist operations in local storage
- `order_service.dart` - Order management in local storage

## Screens (`lib/screens/`)
- `home_screen.dart` - Main landing page with hero sections
- `catalog_screen.dart` - Product grid with filters
- `product_detail_screen.dart` - Product details with image gallery
- `cart_screen.dart` - Shopping cart
- `wishlist_screen.dart` - Saved items
- `profile_screen.dart` - User profile and settings
- `orders_screen.dart` - Order history

## Widgets (`lib/widgets/`)
- `product_card.dart` - Reusable product display
- `category_chip.dart` - Category selector
- `cart_item_widget.dart` - Cart item row

## Theme
- Modern, elegant design with soft colors
- Custom fonts (Playfair Display for headers, Inter for body)
- Generous spacing and rounded corners
- Smooth animations throughout

## Animations
- Page transitions with slide/fade
- Product card hover effects
- Add to cart animations
- Shimmer loading states
- Smooth scroll animations
