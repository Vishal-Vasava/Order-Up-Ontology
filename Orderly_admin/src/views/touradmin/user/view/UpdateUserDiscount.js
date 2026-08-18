// ** Reactstrap Imports
import {
  Button,
  Card,
  CardHeader,
  CardTitle,
  CardBody,
  Col,
  Input,
  Label,
} from "reactstrap";
import React, { useEffect, useState } from "react";
import axios from "axios";
import toast from "react-hot-toast";

import { useNavigate } from "react-router-dom";

// eslint-disable-next-line react/prop-types
const UpdateUserDiscount = ({
  selectedUser,
  isFromScan,
  amount,
  sales,
  sales_description,
  transaction_id,
}) => {
  // console.log("amout", amount);
  const [price, setPrice] = useState(
    amount && amount !== ""
      ? "$" + amount.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,")
      : ""
  );
  const [salesPrice, setSalesPrice] = useState(
    sales && sales !== ""
      ? "$" + sales.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,")
      : ""
  );
  const [salesDescription, setSalesDescription] = useState(
    sales_description ? sales_description : ""
  );
  const [transactionID, setTransactionID] = useState(
    transaction_id ? transaction_id : ""
  );

  const [isLoading, setIsLoading] = useState(false);
  const token = localStorage.getItem("token");

  const navigate = useNavigate();
  // const history = useHistory();

  if (!selectedUser) return <div />;
  const transaction =
    selectedUser &&
    selectedUser.transactions &&
    selectedUser.transactions.length > 0 &&
    selectedUser.transactions[0];

  if (!transaction) return <div />;
  const submitClickdHandler = (event) => {
    event.preventDefault();

    if (isLoading) {
      return;
    }

    setIsLoading(true);

    axios
      .post(
        "/supplier/applyDiscount",
        {
          transaction_id: transaction.id,
          amount: price,
          sales: salesPrice,
          order_id: "100",
          sales_description: salesDescription,
        },
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      )
      .then((response) => {
        // console.log(" : scan result", response.data.data);
        toast.success(response.data.message);

        setIsLoading(false);

        let url = `/admin/scan-data`;
        console.log("ssss", url);
        // history.push(url);
        // history.replace({ pathname: url });
        navigate(url);
      })
      .catch((error) => {
        console.log(error);

        const errorMessage = error.response
          ? error.response.data
            ? error.response.data.message
              ? error.response.data.message
              : "Something went wrong."
            : "Something went wrong."
          : "Something went wrong.";

        toast.error(errorMessage);
        setIsLoading(false);
      });
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle tag="h4">Add Discount</CardTitle>
      </CardHeader>
      <CardBody className="pt-1">
        <Col sm="6" className="mb-1">
          <Label className="form-label" for="price">
            Sales Amount
          </Label>
          <Input
            id="salesPrice"
            type="text"
            name="salsesPrice"
            placeholder="Enter Sales amount"
            value={salesPrice}
            disabled={!isFromScan}
            onChange={(e) => setSalesPrice(e.target.value)}
          />
        </Col>
        <Col sm="6" className="mb-1">
          <Label className="form-label" for="price">
            Discounted Amount
          </Label>
          <Input
            id="price"
            type="text"
            name="price"
            disabled={!isFromScan}
            placeholder="Enter discounted amount"
            value={price}
            onChange={(e) => setPrice(e.target.value)}
          />
        </Col>
        <Col sm="6" className="mb-1">
          <Label className="form-label" for="price">
            Sales Description
          </Label>
          <Input
            id="salesPrice"
            type="text"
            name="salsesPrice"
            placeholder="Enter Sales Description"
            value={salesDescription}
            disabled={!isFromScan}
            onChange={(e) => setSalesDescription(e.target.value)}
          />
        </Col>

        <Col sm="6" className="mb-1">
          <Label className="form-label" for="price">
            Transaction ID
          </Label>
          <Input
            id="transaction_id"
            type="text"
            name="transaction_id"
            placeholder="Enter Transaction ID"
            value={transactionID}
            disabled={!isFromScan}
            onChange={(e) => setTransactionID(e.target.value)}
          />
        </Col>

        {isFromScan && (
          <Button type="submit" color="primary" onClick={submitClickdHandler}>
            Submit
          </Button>
        )}
      </CardBody>
    </Card>
  );
};

export default UpdateUserDiscount;
