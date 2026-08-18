// ** Reactstrap Imports
import { Card, CardBody, CardText, Button } from "reactstrap";
import { useSelector, useDispatch } from "react-redux";

// ** Images
import medal from "@src/assets/images/illustration/pricing-Illustration.svg";
import React from "react";
import { nFormatter } from "../statistics/StatsCardStore";

const CardMedal = () => {
  const stateCnt = useSelector((state) => state.statistic.stististicsCounts);

  return (
    <Card className="card-congratulations-medal">
      <CardBody>
        <h5>Congratulations!</h5>
        <CardText className="font-small-3">Today's Discount Amount</CardText>
        <h3 className="mb-75 mt-2 pt-50">
          <a href="/" onClick={(e) => e.preventDefault()}>
            $
            {nFormatter(
              stateCnt && stateCnt.today_discounted_amt
                ? stateCnt.today_discounted_amt
                : 0
            )}
          </a>
        </h3>
        <Button color="primary">View Details</Button>
        <img className="congratulation-medal" src={medal} alt="Medal Pic" />
      </CardBody>
    </Card>
  );
};

export default CardMedal;
