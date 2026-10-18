
package com.tap.control;

import java.io.IOException;
import java.util.List;

import com.tap.DAOimp.MenuDaoImpl;
import com.tap.modell.Cart;
import com.tap.modell.CartItem;
import com.tap.modell.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class cartcontroller extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================
    // CHECK WHETHER REQUEST IS AJAX
    // =========================================

    private boolean isAjaxRequest(HttpServletRequest req) {

        return "XMLHttpRequest".equals(
            req.getHeader("X-Requested-With")
        );
    }

    // =========================================
    // GET QUANTITY OF A PARTICULAR MENU ITEM
    // =========================================

    private int getItemQuantity(Cart cart, int menuId) {

        if (cart == null || cart.getItems() == null) {
            return 0;
        }

        List<CartItem> items = cart.getItems();

        for (CartItem item : items) {

            if (item.getMenu() != null
                    && item.getMenu().getMenuId() == menuId) {

                return item.getQuantity();
            }
        }

        return 0;
    }

    // =========================================
    // SEND AJAX SUCCESS RESPONSE
    // =========================================

    private void sendAjaxResponse(
            HttpServletResponse resp,
            int menuId,
            int quantity) throws IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-store");

        resp.getWriter().write(
            "{"
                + "\"success\":true,"
                + "\"menuId\":" + menuId + ","
                + "\"quantity\":" + quantity
            + "}"
        );
    }

    // =========================================
    // SEND AJAX ERROR RESPONSE
    // =========================================

    private void sendAjaxError(
            HttpServletResponse resp,
            int status,
            String message) throws IOException {

        resp.setStatus(status);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-store");

        resp.getWriter().write(
            "{"
                + "\"success\":false,"
                + "\"message\":\"" + message + "\""
            + "}"
        );
    }

    // =========================================
    // HANDLE CART ACTIONS
    // =========================================

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");

        boolean ajax = isAjaxRequest(req);

        HttpSession session = req.getSession();

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {

            cart = new Cart();

            session.setAttribute("cart", cart);
        }

        String contextPath = req.getContextPath();

        // =========================================
        // ADD ITEM
        // =========================================

        if ("add".equals(action)) {

            String menuIdParameter =
                req.getParameter("menuId");

            int menuId;

            try {

                menuId = Integer.parseInt(menuIdParameter);

                if (menuId <= 0) {
                    throw new NumberFormatException();
                }

            } catch (NumberFormatException e) {

                if (ajax) {

                    sendAjaxError(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid menu item."
                    );

                } else {

                    resp.sendRedirect(contextPath + "/cart");
                }

                return;
            }

            MenuDaoImpl menuDao = new MenuDaoImpl();

            Menu menu = menuDao.getMenu(menuId);

            if (menu == null || !menu.isAvailable()) {

                if (ajax) {

                    sendAjaxError(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "This menu item is unavailable."
                    );

                } else {

                    resp.sendRedirect(contextPath + "/cart");
                }

                return;
            }

            cart.addItem(menu);

            session.setAttribute("cart", cart);

            // AJAX: NO PAGE REDIRECT

            if (ajax) {

                int updatedQuantity =
                    getItemQuantity(cart, menuId);

                sendAjaxResponse(
                    resp,
                    menuId,
                    updatedQuantity
                );

                return;
            }

            // NORMAL FORM: PRESERVE EXISTING BEHAVIOUR

            String restaurantId =
                req.getParameter("restaurantId");

            if (restaurantId != null
                    && !restaurantId.isEmpty()) {

                resp.sendRedirect(
                    contextPath
                    + "/menu?restaurantId="
                    + restaurantId
                );

            } else {

                resp.sendRedirect(contextPath + "/menu");
            }

            return;
        }

        // =========================================
        // UPDATE ITEM QUANTITY
        // =========================================

        if ("update".equals(action)) {

            String menuIdParameter =
                req.getParameter("menuId");

            String quantityParameter =
                req.getParameter("quantity");

            int menuId;
            int quantity;

            try {

                menuId = Integer.parseInt(menuIdParameter);

                quantity = Integer.parseInt(quantityParameter);

                if (menuId <= 0) {
                    throw new NumberFormatException();
                }

            } catch (NumberFormatException e) {

                if (ajax) {

                    sendAjaxError(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid quantity or menu item."
                    );

                } else {

                    resp.sendRedirect(contextPath + "/cart");
                }

                return;
            }

            // Prevent updating an item that is not in cart.

            int existingQuantity =
                getItemQuantity(cart, menuId);

            if (existingQuantity <= 0) {

                if (ajax) {

                    sendAjaxError(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Item not found in cart."
                    );

                } else {

                    resp.sendRedirect(contextPath + "/cart");
                }

                return;
            }

            if (quantity <= 0) {

                cart.removeItem(menuId);

            } else {

                cart.updateItem(menuId, quantity);
            }

            session.setAttribute("cart", cart);

            // AJAX: RETURN UPDATED QUANTITY

            if (ajax) {

                int updatedQuantity =
                    getItemQuantity(cart, menuId);

                sendAjaxResponse(
                    resp,
                    menuId,
                    updatedQuantity
                );

                return;
            }

            // NORMAL FORM: EXISTING REDIRECT

            String restaurantId =
                req.getParameter("restaurantId");

            if (restaurantId != null
                    && !restaurantId.isEmpty()) {

                resp.sendRedirect(
                    contextPath
                    + "/menu?restaurantId="
                    + restaurantId
                );

            } else {

                resp.sendRedirect(contextPath + "/cart");
            }

            return;
        }

        // =========================================
        // REMOVE SINGLE ITEM
        // =========================================

        if ("remove".equals(action)) {

            String menuIdParameter =
                req.getParameter("menuId");

            if (menuIdParameter != null
                    && !menuIdParameter.isEmpty()) {

                try {

                    int menuId =
                        Integer.parseInt(menuIdParameter);

                    cart.removeItem(menuId);

                } catch (NumberFormatException e) {

                    // Ignore invalid menu ID.
                }
            }

            session.setAttribute("cart", cart);

            resp.sendRedirect(contextPath + "/cart");

            return;
        }

        // =========================================
        // CLEAR ENTIRE CART
        // =========================================

        if ("clear".equals(action)) {

            cart.clearCart();

            session.setAttribute("cart", cart);

            resp.sendRedirect(contextPath + "/cart");

            return;
        }

        // =========================================
        // DEFAULT RESPONSE
        // =========================================

        if (ajax) {

            sendAjaxError(
                resp,
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid cart action."
            );

        } else {

            resp.sendRedirect(contextPath + "/cart");
        }
    }

    // =========================================
    // DISPLAY CART PAGE
    // =========================================

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/cart.jsp")
           .forward(req, resp);
    }
}
