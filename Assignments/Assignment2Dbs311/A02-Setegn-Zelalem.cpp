/*
--********************************
-- Name: Zelalem Setegn
-- ID: 131846206
-- Date: August 2,2021
-- Purpose: Assignment 2 DBS311
--*******************************
*/

#include <iostream>
#include <occi.h>

using oracle::occi::Environment;
using oracle::occi::Connection;

using namespace oracle::occi;
using namespace std;


struct ShoppingCart {
	int product_id;
	double price;
	int quantity;
};

const int MAX_CART_SIZE = 5;	// the max number of items in one customer order

int mainMenu();
int customerLogin(Connection* conn, int customerId);
int addToCart(Connection* conn, struct ShoppingCart cart[]);
double findProduct(Connection* conn, int product_id);
void displayProducts(struct ShoppingCart cart[], int productCount);
int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount);

int main()
{
	// OCCI Variables
	Environment* env = nullptr;
	Connection* conn = nullptr;
	// Used Variables
	string str;
	string user = "dbs311_212d03";
	string pass = "13751279";
	string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";
	try
	{
		env = Environment::createEnvironment(Environment::DEFAULT);
		conn = env->createConnection(user, pass, constr);
		cout << "Connection is Successful!" << endl;

		Statement* stmt = conn->createStatement();
		stmt->execute("CREATE OR REPLACE PROCEDURE find_customer (p_customer_id IN NUMBER, found OUT NUMBER) IS"
			" v_custid NUMBER;"
			" BEGIN"
			" found:=1;"
			" SELECT customer_id"
			" INTO v_custid"
			" FROM customers"
			" WHERE customer_id=p_customer_id;"
			" EXCEPTION"
			" WHEN NO_DATA_FOUND THEN"
			" found:=0;"
			" END;"
		);

		stmt->execute("CREATE OR REPLACE PROCEDURE find_product(p_product_id IN NUMBER, price OUT products.list_price%TYPE) IS"
			" BEGIN"
			" SELECT list_price INTO price"
			" FROM products"
			" WHERE product_id=p_product_id;"
			" EXCEPTION"
			" WHEN NO_DATA_FOUND THEN"
			" price:=0;"
			" END;"
		);

		stmt->execute("CREATE OR REPLACE PROCEDURE add_order(p_customer_id IN NUMBER, new_order_id OUT NUMBER) IS"
			" BEGIN"
			" SELECT MAX(order_id) INTO new_order_id"
			" FROM orders;"
			" new_order_id:=new_order_id+1;"
			" INSERT INTO orders"
			" VALUES(new_order_id, p_customer_id, 'Shipped', 56, sysdate);"
			" END;"
		);

		stmt->execute("CREATE OR REPLACE PROCEDURE"
			" add_order_item(orderId IN order_items.order_id % type,"
			" itemId IN order_items.item_id % type,"
			" productId IN order_items.product_id % type,"
			" quantity IN order_items.quantity % type,"
			" price IN order_items.unit_price % type)"
			" IS"
			" BEGIN"
			" INSERT INTO order_items"
			" VALUES(orderId, itemId, productId, quantity, price);"
			" END;"
		);

		ShoppingCart cart[MAX_CART_SIZE];
		int option = 0, id = 0, exists = 0, count = 0;
		do
		{
			// display the main menu options
			option = mainMenu();
			switch (option)
			{
			case 1:
				// prompt the user to enter the customer ID
				cout << "Enter the customer ID: ";
				cin >> id;
				// if the customer ID exists, continue with rest of the program
				exists = customerLogin(conn, id);
				if (exists)
				{
					count = addToCart(conn, cart);
					displayProducts(cart, count);
					checkout(conn, cart, id, count);
				}
				else
				{
					cout << "The customer does not exist." << endl;
				}
				break;
			case 0:
				cout << "Good bye!..." << endl;
				return 0;
			}
		} while (option != 0);	// continue looping until the user enters 0 to exit the program

		env->terminateConnection(conn);
		Environment::terminateEnvironment(env);
	}
	catch (SQLException& sqlExcp)
	{
		cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
	}
	return 0;
}

// returns the integer value which is the selected option by the user from the menu
int mainMenu()
{
	cout << "******************** Main Menu ********************" << endl;
	cout << "1) Login" << endl;
	cout << "0) Exit" << endl;
	cout << "Enter an option (0-1): ";

	int choice;
	char newline;
	bool done;
	// check if the user enters a valid option
	// continue prompting the user until a valid option is entered
	do
	{
		cin >> choice;
		newline = cin.get();
		if (cin.fail() || newline != '\n')
		{
			done = false;
			cin.clear();
			cin.ignore(1000, '\n');
			cout << "You entered a wrong value. Enter an option (0-1): ";
		}
		else
		{
			done = choice >= 0 && choice <= 1;
			if (!done)
			{
				cout << "******************** Main Menu ********************" << endl;
				cout << "1) Login" << endl;
				cout << "0) Exit" << endl;
				cout << "You entered a wrong value. Enter an option (0-1): ";
			}
		}
	} while (!done);
	return choice;
}

// checks if the customer exists in the database
// if customer exists, found is 1, otherwise found is 0
int customerLogin(Connection* conn, int customerId)
{
	int found = 0;
	Statement* stmt = conn->createStatement();
	// call the find_customer procedure
	stmt->setSQL("BEGIN"
		" find_customer(:1, :2);"
		" END;"
	);
	stmt->setNumber(1, customerId);
	stmt->registerOutParam(2, Type::OCCIINT, sizeof(found));
	stmt->executeUpdate();
	// store the out parameter into found
	found = stmt->getInt(2);

	return found;
}

// Add the product to the cart
int addToCart(Connection* conn, ShoppingCart cart[]) {
	ShoppingCart shopCart;
	int i,
		prodID = -1,
		prodQTY = -1,
		prodNUM = 0,
		selection;
	cout << "-------------- Add Products to Cart --------------" << endl;
	for (i = 0; i < MAX_CART_SIZE; i++) {
		do {
			cout << "Enter the product ID: ";
			cin >> prodID;
			cout << isdigit(prodID);
			if (findProduct(conn, prodID) == 0) {
				cout << "The product does not exist. Try again..." << endl;
			}
		} while (findProduct(conn, prodID) == 0);
		cout << "Product Price: " << findProduct(conn, prodID) << endl;
		cout << "Enter the product Quantity: ";
		cin >> prodQTY;
		shopCart.product_id = prodID;
		shopCart.price = findProduct(conn, prodID);
		shopCart.quantity = prodQTY;
		cart[i] = shopCart;

		if (i == 4) {
			i = 5;
		}
		else {
			do {
				cout << "Enter 1 to add more products or 0 to checkout: ";
				cin >> selection;
			} while (selection != 0 && selection != 1);
		}
		if (selection == 0) {
			i = 5;
		}
		prodNUM++;
	}
	return prodNUM;
}

// returns the price of the product with ID of product_id
// returns 0 if the product ID is not valid
double findProduct(Connection* conn, int product_id)
{
	Statement* stmt = conn->createStatement();
	// call the find_product stored procedure
	stmt->setSQL("BEGIN"
		" find_product(:1, :2);"
		" END;");
	double price = 0;
	stmt->setNumber(1, product_id);
	stmt->registerOutParam(2, Type::OCCIDOUBLE, sizeof(price));
	stmt->executeUpdate();
	// store the out parameter into price
	price = stmt->getDouble(2);
	conn->terminateStatement(stmt);
	return price;
}

// displays the products added by the user to the shopping cart
void displayProducts(struct ShoppingCart cart[], int productCount)
{
	double total = 0;
	cout << "------- Ordered Products ---------" << endl;
	for (auto i = 0; i < productCount; i++)
	{
		cout << "---Item " << i + 1 << endl;
		cout << "Product ID: " << cart[i].product_id << endl;
		cout << "Price: " << cart[i].price << endl;
		cout << "Quantity: " << cart[i].quantity << endl;
		// add to the total order amount
		total += cart[i].quantity * cart[i].price;
	}
	cout << "----------------------------------" << endl;
	// display the total amount
	cout << "Total: " << total << endl;
}

int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount)
{
	int newOrderId = 0;
	char choice;
	char newline;
	do
	{
		// ask the user if they want to checkout
		cout << "Would you like to checkout? (Y/y or N/n) ";
		cin >> choice;
		// check if the user entered a valid option
		newline = cin.get();
		if (cin.fail() || newline != '\n')
		{
			cin.clear();
			cin.ignore(1000, '\n');
			cout << "Wrong input. Try again..." << endl;
		}
		else
		{
			if (choice != 'Y' && choice != 'y' && choice != 'N' && choice != 'n')
			{
				cout << "Wrong input. Try again..." << endl;
			}
		}
		// keep asking the user until they enter a valid choice
	} while (choice != 'Y' && choice != 'y' && choice != 'N' && choice != 'n');

	if (choice == 'Y' || choice == 'y')
	{
		Statement* stmt = conn->createStatement();
		// call the add_order stored procedure
		stmt->setSQL("BEGIN"
			" add_order(:1, :2);"
			" END;"
		);
		stmt->setNumber(1, customerId);
		stmt->registerOutParam(2, Type::OCCIINT, sizeof(newOrderId));
		stmt->executeUpdate();
		// save the returning value of the out parameter into newOrderId
		newOrderId = stmt->getInt(2);
		conn->terminateStatement(stmt);
	}
	else
	{
		cout << "The order is cancelled." << endl;
		return 0;
	}

	Statement* stmt = conn->createStatement();
	// for each item in the cart, call the stored procedure add_order_item
	for (auto i = 0; i < productCount; i++)
	{
		stmt->setSQL("BEGIN"
			" add_order_item(:1, :2, :3, :4, :5);"
			" END;"
		);
		stmt->setNumber(1, newOrderId);
		stmt->setNumber(2, i + 1);
		stmt->setNumber(3, cart[i].product_id);
		stmt->setNumber(4, cart[i].quantity);
		stmt->setDouble(5, cart[i].price);
	}
	conn->terminateStatement(stmt);

	cout << "The order is successfully completed." << endl;
	return 1;
}
