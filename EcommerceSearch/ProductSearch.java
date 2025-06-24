import java.util.Arrays;
import java.util.Comparator;

public class ProductSearch {

    public static Product linearSearch(Product[] products, int id) {
        for (Product product : products) {
            if (product.productId == id) {
                return product;
            }
        }
        return null;
    }

    public static Product binarySearch(Product[] products, int id) {
        int left = 0;
        int right = products.length - 1;

        while (left <= right) {
            int mid = (left + right) / 2;
            if (products[mid].productId == id) {
                return products[mid];
            } else if (products[mid].productId < id) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return null;
    }

    public static void main(String[] args) {
        Product[] products = {
            new Product(104, "Laptop", "Electronics"),
            new Product(102, "Shirt", "Clothing"),
            new Product(101, "Book", "Education"),
            new Product(103, "Shoes", "Footwear")
        };

        // Linear Search
        System.out.println("Linear Search:");
        Product result1 = linearSearch(products, 103);
        System.out.println(result1 != null ? result1 : "Product not found");

        // Sort for Binary Search
        Arrays.sort(products, Comparator.comparingInt(p -> p.productId));

        // Binary Search
        System.out.println("Binary Search:");
        Product result2 = binarySearch(products, 103);
        System.out.println(result2 != null ? result2 : "Product not found");
    }
}
