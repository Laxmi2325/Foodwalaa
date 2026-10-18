<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.modell.Menu" %>
<%@ page import="com.tap.modell.Cart" %>
<%@ page import="com.tap.modell.CartItem" %>
<%!
    private String safe(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;")
                    .replace(">", "&gt;").replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>
<%
    String contextPath = request.getContextPath();
    String restaurantId = request.getParameter("restaurantId");
    if (restaurantId == null) restaurantId = "";
    List<Menu> menus = (List<Menu>) request.getAttribute("allmenu");
    Cart cart = (Cart) session.getAttribute("cart");
    if (cart == null) cart = new Cart();
    List<CartItem> cartItems = cart.getItems();
    String fallbackImage = contextPath + "/images/branding/foodwala-logo.png";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Explore Menu | Foodwala</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
html{scroll-behavior:smooth}
body{min-height:100vh;font-family:Arial,sans-serif;background:#fff7f2;color:#222;display:flex;flex-direction:column;overflow-x:hidden}
button{font-family:inherit}
.header{position:sticky;top:0;z-index:1000;min-height:76px;padding:10px 6%;background:#111;display:flex;justify-content:space-between;align-items:center;gap:15px;box-shadow:0 4px 22px rgba(0,0,0,.16)}
.logo{display:inline-flex;align-items:center;flex-shrink:0;text-decoration:none;line-height:0}
.brand-logo{display:block;width:155px;height:auto;max-height:58px;object-fit:contain;transition:transform .35s ease,filter .35s ease}
.logo:hover .brand-logo{transform:scale(1.07);filter:brightness(1.15)}
.header-right{display:flex;align-items:center;gap:24px}
.location{color:#ddd;font-size:14px;white-space:nowrap}
.nav-link{position:relative;color:white;text-decoration:none;font-size:14px;font-weight:bold;padding:8px 0;transition:color .3s ease;white-space:nowrap}
.nav-link::after{content:"";position:absolute;bottom:0;left:0;width:0;height:2px;background:#ff6b35;transition:width .3s ease}
.nav-link:hover{color:#ff6b35}.nav-link:hover::after{width:100%}
.cart-link{display:inline-flex;align-items:center;justify-content:center;gap:7px;background:#ff6b35;color:white;text-decoration:none;padding:11px 19px;border-radius:25px;font-size:14px;font-weight:bold;white-space:nowrap;transition:background .3s ease,transform .3s ease,box-shadow .3s ease}
.cart-link:hover{background:#f05a26;transform:translateY(-2px);box-shadow:0 7px 18px rgba(255,107,53,.25)}
.page-intro{position:relative;background:radial-gradient(circle at 90% 20%,rgba(255,107,53,.11),transparent 35%),linear-gradient(135deg,#fff7f2,#fffdfb);padding:55px 7% 45px;overflow:hidden}
.page-header{position:relative;width:100%;max-width:1200px;margin:0 auto;animation:fadeUp .6s ease both}
.eyebrow{color:#ff6b35;font-size:12px;font-weight:bold;letter-spacing:2px;margin-bottom:13px}
.page-header h1{color:#111;font-size:38px;font-weight:800;line-height:1.2;margin-bottom:13px}.page-header h1 span{color:#ff6b35}
.page-header p{color:#777;font-size:15px;line-height:1.7;max-width:550px}
.back-link{display:inline-flex;align-items:center;gap:7px;color:#333;text-decoration:none;font-size:13px;font-weight:bold;margin-top:22px;transition:color .3s ease,transform .3s ease}.back-link:hover{color:#ff6b35;transform:translateX(-3px)}
.menu-container{width:86%;max-width:1200px;margin:38px auto 85px;display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:27px;flex:1}
.menu-card{background:white;border-radius:19px;overflow:hidden;border:1px solid rgba(0,0,0,.045);box-shadow:0 5px 18px rgba(0,0,0,.07);display:flex;flex-direction:column;animation:fadeUp .65s ease both;transition:transform .35s ease,box-shadow .35s ease,border-color .35s ease}
.menu-card:nth-child(3n + 2){animation-delay:.07s}.menu-card:nth-child(3n + 3){animation-delay:.14s}
.menu-card:hover{transform:translateY(-7px);border-color:rgba(255,107,53,.22);box-shadow:0 15px 35px rgba(0,0,0,.12)}
.image-container{position:relative;width:100%;height:225px;overflow:hidden;background:#191919}
.food-image{display:block;width:100%;height:100%;object-fit:cover;transition:transform .55s ease,filter .55s ease}.menu-card:hover .food-image{transform:scale(1.075);filter:saturate(1.1)}
.image-container::after{content:"";position:absolute;inset:0;background:linear-gradient(to top,rgba(0,0,0,.18),transparent 55%);pointer-events:none}
.food-label{position:absolute;left:15px;top:15px;z-index:1;background:#111;color:white;padding:7px 13px;border-radius:20px;font-size:11px;font-weight:bold;letter-spacing:.3px;box-shadow:0 4px 12px rgba(0,0,0,.15)}
.menu-content{padding:22px;display:flex;flex-direction:column;flex:1}
.item-header{display:flex;justify-content:space-between;align-items:flex-start;gap:12px;margin-bottom:12px}
.item-name{color:#171717;font-size:19px;font-weight:800;line-height:1.35;overflow-wrap:anywhere}
.item-price{color:#ff6b35;font-size:18px;font-weight:800;white-space:nowrap}
.description{color:#777;font-size:13px;line-height:1.7;margin-bottom:23px;min-height:46px;overflow-wrap:anywhere}
.card-bottom{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;margin-top:auto;padding-top:15px;border-top:1px solid #f4eee9}
.available{color:#267a3e;font-size:12px;font-weight:bold}.unavailable{color:#d9534f;font-size:12px;font-weight:bold}
.add-cart{border:none;background:#ff6b35;color:white;padding:11px 19px;border-radius:25px;font-size:13px;font-weight:bold;cursor:pointer;transition:background .3s ease,transform .3s ease,box-shadow .3s ease}
.add-cart:hover{background:#111;transform:translateY(-2px);box-shadow:0 7px 16px rgba(0,0,0,.16)}.add-cart:active{transform:scale(.97)}
.quantity-control{display:inline-flex;align-items:center;background:#111;border-radius:25px;overflow:hidden;box-shadow:0 4px 12px rgba(0,0,0,.10)}
.quantity-control form,.cart-controls form{margin:0}
.quantity-button{display:flex;align-items:center;justify-content:center;width:36px;height:36px;border:none;background:#111;color:white;font-size:19px;font-weight:bold;cursor:pointer;transition:background .25s ease}
.quantity-button:hover{background:#ff6b35}.quantity-button:active{background:#e65320}
.quantity-value{min-width:35px;text-align:center;color:white;font-size:14px;font-weight:bold}
.menu-card[data-loading="true"] .add-cart,.menu-card[data-loading="true"] .quantity-button{opacity:.65;cursor:wait}
.cart-controls{display:inline-flex;align-items:center}.cart-controls.updated{animation:cartPop .25s ease}
.cart-error{color:#b42318;font-size:12px;line-height:1.5;margin-top:10px}.cart-error[hidden]{display:none}
@keyframes cartPop{0%{transform:scale(.94)}70%{transform:scale(1.05)}100%{transform:scale(1)}}
.disabled-button{border:none;background:#e8e8e8;color:#888;padding:11px 18px;border-radius:25px;font-size:13px;font-weight:bold;cursor:not-allowed}
.empty-menu{width:86%;max-width:600px;margin:50px auto 100px;padding:55px 30px;text-align:center;background:white;border-radius:20px;box-shadow:0 8px 25px rgba(0,0,0,.08);animation:fadeUp .6s ease both}.empty-menu h2{color:#111;margin-bottom:12px}.empty-menu p{color:#777;font-size:14px;line-height:1.6}
.footer{background:#111;color:#aaa;text-align:center;padding:27px 20px;font-size:13px;line-height:1.6;margin-top:auto}.footer span{color:#ff6b35;font-weight:bold}
@keyframes fadeUp{from{opacity:0;transform:translateY(25px)}to{opacity:1;transform:translateY(0)}}
@media(max-width:1000px){.menu-container{grid-template-columns:repeat(2,minmax(0,1fr));width:90%}.header{padding:12px 4%}}
@media(max-width:650px){.header{min-height:70px;padding:12px 15px}.brand-logo{width:115px;max-height:48px}.header-right{gap:12px}.location{display:none}.nav-link{font-size:12px}.cart-link{padding:9px 13px;font-size:12px}.page-intro{padding:37px 5% 32px}.page-header h1{font-size:29px}.page-header p{font-size:13px}.menu-container{grid-template-columns:1fr;width:92%;gap:22px;margin-top:28px}.image-container{height:230px}}
@media(max-width:390px){.brand-logo{width:95px;max-height:42px}.header-right{gap:8px}.nav-link{font-size:11px}.cart-link{padding:8px 10px;font-size:11px}.menu-content{padding:18px}.item-name{font-size:17px}}
@media(prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:.01ms!important;transition-duration:.01ms!important}}
</style>
</head>
<body>
<header class="header">
    <a href="<%= contextPath %>/restaurant" class="logo" aria-label="Foodwala Home">
        <img src="<%= contextPath %>/images/branding/foodwala-logo.png" alt="Foodwala" class="brand-logo">
    </a>
    <div class="header-right">
        <span class="location">&#128205; Bengaluru</span>
        <a href="<%= contextPath %>/restaurant" class="nav-link">Restaurants</a>
        <a href="<%= contextPath %>/cart" class="cart-link">&#128722; Cart</a>
    </div>
</header>
<section class="page-intro">
    <div class="page-header">
        <div class="eyebrow">MADE FOR FOOD LOVERS</div>
        <h1>Explore Our <span>Menu</span></h1>
        <p>Discover delicious dishes, choose your favourites and add them to your Foodwala cart.</p>
        <a href="<%= contextPath %>/restaurant" class="back-link">&#8592; Back to Restaurants</a>
    </div>
</section>
<% if (menus != null && !menus.isEmpty()) { %>
<main class="menu-container">
<% for (Menu menu : menus) {
    int currentQuantity = 0;
    if (cartItems != null) {
        for (CartItem cartItem : cartItems) {
            if (cartItem.getMenu() != null && cartItem.getMenu().getMenuId() == menu.getMenuId()) {
                currentQuantity = cartItem.getQuantity();
                break;
            }
        }
    }
    String imageUrl = menu.getImagePath();
    if (imageUrl == null || imageUrl.trim().isEmpty()) {
        imageUrl = fallbackImage;
    } else {
        imageUrl = imageUrl.trim();
        if (imageUrl.startsWith("http://") || imageUrl.startsWith("https://")) {
            // External image URL.
        } else if (imageUrl.startsWith(contextPath + "/")) {
            // Context path already present.
        } else if (imageUrl.startsWith("/")) {
            imageUrl = contextPath + imageUrl;
        } else {
            imageUrl = contextPath + "/" + imageUrl;
        }
    }
%>
<article class="menu-card" data-menu-id="<%= menu.getMenuId() %>">
    <div class="image-container">
        <img src="<%= safe(imageUrl) %>" alt="<%= safe(menu.getItemName()) %>" class="food-image" loading="lazy" onerror="this.onerror=null;this.src='<%= safe(fallbackImage) %>';">
        <span class="food-label">FOODWALA</span>
    </div>
    <div class="menu-content">
        <div class="item-header">
            <h2 class="item-name"><%= safe(menu.getItemName()) %></h2>
            <span class="item-price">&#8377;<%= String.format("%.0f", menu.getPrice()) %></span>
        </div>
        <p class="description"><%= safe(menu.getDescription()) %></p>
        <div class="card-bottom">
        <% if (menu.isAvailable()) { %>
            <span class="available">&#9679; Available</span>
            <div class="cart-controls" data-restaurant-id="<%= safe(restaurantId) %>">
            <% if (currentQuantity == 0) { %>
                <form action="<%= contextPath %>/cart" method="post" class="ajax-cart-form">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                    <input type="hidden" name="restaurantId" value="<%= safe(restaurantId) %>">
                    <button type="submit" class="add-cart">Add to Cart</button>
                </form>
            <% } else { %>
                <div class="quantity-control">
                    <form action="<%= contextPath %>/cart" method="post" class="ajax-cart-form">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                        <input type="hidden" name="quantity" value="<%= currentQuantity - 1 %>">
                        <input type="hidden" name="restaurantId" value="<%= safe(restaurantId) %>">
                        <button type="submit" class="quantity-button" aria-label="Decrease quantity">&#8722;</button>
                    </form>
                    <span class="quantity-value"><%= currentQuantity %></span>
                    <form action="<%= contextPath %>/cart" method="post" class="ajax-cart-form">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                        <input type="hidden" name="quantity" value="<%= currentQuantity + 1 %>">
                        <input type="hidden" name="restaurantId" value="<%= safe(restaurantId) %>">
                        <button type="submit" class="quantity-button" aria-label="Increase quantity">+</button>
                    </form>
                </div>
            <% } %>
            </div>
        <% } else { %>
            <span class="unavailable">&#9679; Unavailable</span>
            <button type="button" class="disabled-button" disabled>Unavailable</button>
        <% } %>
        </div>
        <p class="cart-error" role="alert" hidden></p>
    </div>
</article>
<% } %>
</main>
<% } else { %>
<main class="empty-menu">
    <h2>No Menu Items Found</h2>
    <p>This restaurant currently has no menu items available.</p>
    <a href="<%= contextPath %>/restaurant" class="back-link">&#8592; Explore Restaurants</a>
</main>
<% } %>
<footer class="footer">&#169; 2026 <span>Foodwala</span> &bull; Delicious food, delivered with care.</footer>
<script>
document.addEventListener("DOMContentLoaded", function () {
    const menuContainer = document.querySelector(".menu-container");
    if (!menuContainer) return;

    menuContainer.addEventListener("submit", async function (event) {
        const form = event.target;
        if (!(form instanceof HTMLFormElement) || !form.classList.contains("ajax-cart-form")) return;
        event.preventDefault();

        const card = form.closest(".menu-card");
        if (!card || card.dataset.loading === "true") return;
        const controls = card.querySelector(".cart-controls");
        const errorElement = card.querySelector(".cart-error");
        if (!controls || !errorElement) return;

        const menuId = card.dataset.menuId;
        const restaurantId = controls.dataset.restaurantId || "";
        // IMPORTANT: a hidden input named action shadows the form.action property.
        // Read the URL from the actual HTML attribute instead.
        const cartUrl = form.getAttribute("action");
        errorElement.hidden = true;
        errorElement.textContent = "";
        card.dataset.loading = "true";
        card.querySelectorAll("button").forEach(button => button.disabled = true);

        try {
            const formData = new FormData(form);
            const response = await fetch(cartUrl, {
                method: "POST",
                body: new URLSearchParams(formData),
                credentials: "same-origin",
                redirect: "follow",
                headers: {
                    "X-Requested-With": "XMLHttpRequest",
                    "Accept": "application/json",
                    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                }
            });
            const contentType = response.headers.get("content-type") || "";
            if (!contentType.toLowerCase().includes("application/json")) {
                throw new Error("The cart server returned a page instead of JSON. Check that the updated cartcontroller.java is published in Tomcat.");
            }
            const data = await response.json();
            if (!response.ok || data.success !== true) {
                throw new Error(data.message || "Unable to update cart.");
            }
            if (Number(data.menuId) !== Number(menuId)) {
                throw new Error("The server returned a different menu item.");
            }
            const quantity = Number(data.quantity);
            if (!Number.isSafeInteger(quantity) || quantity < 0) {
                throw new Error("Invalid quantity returned by the server.");
            }
            renderCartControls(controls, cartUrl, menuId, restaurantId, quantity);
        } catch (error) {
            console.error("Foodwala AJAX cart error:", error);
            errorElement.textContent = error.message || "Unable to update cart.";
            errorElement.hidden = false;
        } finally {
            card.dataset.loading = "false";
            card.querySelectorAll("button").forEach(button => button.disabled = false);
        }
    });

    function createCartForm(cartUrl, actionValue, menuId, restaurantId, quantity, buttonText, buttonClass, ariaLabel) {
        const newForm = document.createElement("form");
        // setAttribute also avoids the input-name/action property collision.
        newForm.setAttribute("action", cartUrl);
        newForm.setAttribute("method", "post");
        newForm.className = "ajax-cart-form";
        function addHiddenInput(name, value) {
            const input = document.createElement("input");
            input.type = "hidden";
            input.name = name;
            input.value = String(value);
            newForm.appendChild(input);
        }
        addHiddenInput("action", actionValue);
        addHiddenInput("menuId", menuId);
        addHiddenInput("restaurantId", restaurantId);
        if (quantity !== null) addHiddenInput("quantity", quantity);
        const button = document.createElement("button");
        button.type = "submit";
        button.className = buttonClass;
        button.textContent = buttonText;
        if (ariaLabel) button.setAttribute("aria-label", ariaLabel);
        newForm.appendChild(button);
        return newForm;
    }

    function renderCartControls(controls, cartUrl, menuId, restaurantId, quantity) {
        controls.replaceChildren();
        if (quantity === 0) {
            controls.appendChild(createCartForm(cartUrl, "add", menuId, restaurantId, null,
                "Add to Cart", "add-cart", "Add item to cart"));
        } else {
            const quantityControl = document.createElement("div");
            quantityControl.className = "quantity-control";
            quantityControl.appendChild(createCartForm(cartUrl, "update", menuId, restaurantId, quantity - 1,
                "\u2212", "quantity-button", "Decrease quantity"));
            const quantityValue = document.createElement("span");
            quantityValue.className = "quantity-value";
            quantityValue.textContent = String(quantity);
            quantityControl.appendChild(quantityValue);
            quantityControl.appendChild(createCartForm(cartUrl, "update", menuId, restaurantId, quantity + 1,
                "+", "quantity-button", "Increase quantity"));
            controls.appendChild(quantityControl);
        }
        controls.classList.remove("updated");
        void controls.offsetWidth;
        controls.classList.add("updated");
    }
});
</script>
</body>
</html>
