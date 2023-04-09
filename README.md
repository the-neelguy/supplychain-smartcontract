# Smart Contract for Generic Supply Chain Management


The working of the smart contract is stated below:

1. This smart contract is based upon Ethereum and can be deployed into any Ethereum network for testing purposes.
2. This smart contract can have multiple stakeholders of the supply chain including Farmer(Producer), Manufacturer, Distributor(Wholesaler), Retailer and Customer(Consumer).
3. The stakeholders can add themselves into the network without the consent of any central authority. Also each of them are defined with specific set of roles.
4. The Roles of a farmer are defined below:

•	A farmer first produces their raw matrials and list them in the contract <br>
•	A farmer can choose which items to sell and list them for selling with appropriate price <br>
•	When a manufacturer buys with the proper amount, the farmer can ship the product to the manufacturer <br>

5. The Roles of a manufacturer are defined below:

•	The Manufacture can buy product from any farmer with instant payment method <br>
•	The Manufacturer then processes the raw materials <br>
•	It moves on to packaging <br>
•	Finally the manufacturer list its product for sell with appropriate price <br>
•	After a distributor buys with the proper amount, the manufacturer ships the product to the distributor <br>

6. The Roles of a distributor are defined below:

•	The Distributor buys the product from the Manufacturer with instant payment <br>
•	The Distributor then stores them in their warehouse <br>
•	Finally the distributor list its product for sell with appropriate price <br>
•	After a retailer buys with the proper amount, the distributor ships the product to the retailer <br>

7. The Roles of a retailer are defined below:

•	The Retailer buys the product from the Distributor with instant payment <br>
•	The Retailer then stores them in their individual shops <br>
•	Finally the retailer list its product for sell with appropriate price <br>

8. The Roles of a customer are defined below:

•	The customer buys the product from the retailer with instant payment <br>
    
In the complete above scenario, starting from raw materials produced till the finished product with the customer, everything can be tracked. A function called getState returns the state of the product after every specified action. This enhances the transparency and trackability of the complete supply chain.

Also at every state the owndership of the product can be checked which enhances the single source of truth.
