// ** User List Component
import Table from "./Table";

// ** Reactstrap Imports
import { Row, Col } from "reactstrap";

// ** Custom Components
import StatsHorizontal from "@components/widgets/stats/StatsHorizontal";

// ** Icons Imports
import { User, UserPlus, UserCheck, UserX, Coffee } from "react-feather";

// ** Styles
import "@styles/react/apps/app-users.scss";
import {
  DriveEta,
  Flight,
  Hotel,
  Restaurant,
  Shop,
  Shop2,
  Storefront,
  Tour,
} from "@mui/icons-material";

const UsersList = ({ selectedUser }) => {
  return (
    <div className="app-user-list">
      <Row>
        {selectedUser &&
          selectedUser.transactions &&
          selectedUser.transactions.map((item) => {
            let icon = <Hotel size={20} />;
            let color = "danger";
            switch (item.supplier_type_id) {
              case 1:
                icon = <Flight size={20} />;
                color = "primary";
                break;
              case 2:
                icon = <Hotel size={20} />;
                color = "success";
                break;
              case 3:
                icon = <Restaurant size={20} />;
                color = "warning";
                break;
              case 4:
                icon = <Tour size={20} />;
                color = "danger";
                break;
              case 5:
                icon = <Storefront size={20} />;
                color = "primary";
                break;
              case 6:
                icon = <DriveEta size={20} />;
                color = "warning";
                break;
              default:
                break;
            }

            return (
              <Col lg="6" sm="6" key={item.id}>
                <StatsHorizontal
                  color={color}
                  statTitle={item.supplier_type}
                  icon={icon}
                  renderStats={
                    <h3 className="fw-bolder mb-75">{item.certificates}</h3>
                  }
                />
              </Col>
            );
          })}
      </Row>
    </div>
  );
};

export default UsersList;
