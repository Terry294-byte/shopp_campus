class AssetsManager {
  // Base path for all assets
  static const String _basePath = 'assets/images';
  
  // General images
  static const String addressMap = '$_basePath/address_map.png';
  static const String banner2 = '$_basePath/banner2.png';
  static const String emptySearch = '$_basePath/empty_search.png';
  static const String error = '$_basePath/error.png';
  static const String forgotPassword = '$_basePath/forgot_password.jpg';
  static const String roundedMap = '$_basePath/rounded_map.png';
  static const String successful = '$_basePath/successful.png';
  static const String warning = '$_basePath/warning.png';
  
  // Bag related images
  static const String bagWish = '$_basePath/bag/bag_wish.png';
  static const String orderSvg = '$_basePath/bag/order_svg.png';
  static const String order = '$_basePath/bag/order.png';
  static const String shoppingBasket = '$_basePath/bag/shopping_basket.png';
  static const String shoppingCart = '$_basePath/bag/shopping_cart.png';
  static const String wishlistSvg = '$_basePath/bag/wishlist_svg.png';
  
  // Banners
  static const String banner1 = '$_basePath/banners/banner1.png';
  static const String banner2Banner = '$_basePath/banners/banner2.png';
  
  // Categories
  static const String bookImg = '$_basePath/categories/book_img.png';
  static const String cosmetics = '$_basePath/categories/cosmetics.png';
  static const String electronics = '$_basePath/categories/electronics.png';
  static const String fashion = '$_basePath/categories/fashion.png';
  static const String mobiles = '$_basePath/categories/mobiles.png';
  static const String pc = '$_basePath/categories/pc.png';
  static const String shoes = '$_basePath/categories/shoes.png';
  static const String watch = '$_basePath/categories/watch.png';
  
  // Profile
  static const String address = '$_basePath/profile/address.png';
  static const String login = '$_basePath/profile/login.png';
  static const String logout = '$_basePath/profile/logout.png';
  static const String privacy = '$_basePath/profile/privacy.png';
  static const String recent = '$_basePath/profile/recent.png';
  static const String theme = '$_basePath/profile/theme.png';
  
  // Helper method to get image by category
  static String getCategoryImage(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'book':
      case 'books':
        return bookImg;
      case 'cosmetics':
        return cosmetics;
      case 'electronics':
        return electronics;
      case 'fashion':
        return fashion;
      case 'mobile':
      case 'mobiles':
        return mobiles;
      case 'pc':
      case 'computer':
        return pc;
      case 'shoe':
      case 'shoes':
        return shoes;
      case 'watch':
      case 'watches':
        return watch;
      default:
        return error;
    }
  }
  
  // Helper method to get all category images
  static Map<String, String> getAllCategories() {
    return {
      'Books': bookImg,
      'Cosmetics': cosmetics,
      'Electronics': electronics,
      'Fashion': fashion,
      'Mobiles': mobiles,
      'PC': pc,
      'Shoes': shoes,
      'Watch': watch,
    };
  }
  
  // Helper method to get all banners
  static List<String> getAllBanners() {
    return [banner1, banner2Banner];
  }
  
  // Helper method to get all profile images
  static Map<String, String> getAllProfileImages() {
    return {
      'Address': address,
      'Login': login,
      'Logout': logout,
      'Privacy': privacy,
      'Recent': recent,
      'Theme': theme,
    };
  }
  
  // Helper method to get all bag images
  static Map<String, String> getAllBagImages() {
    return {
      'Bag Wish': bagWish,
      'Order SVG': orderSvg,
      'Order': order,
      'Shopping Basket': shoppingBasket,
      'Shopping Cart': shoppingCart,
      'Wishlist SVG': wishlistSvg,
    };
  }
}
