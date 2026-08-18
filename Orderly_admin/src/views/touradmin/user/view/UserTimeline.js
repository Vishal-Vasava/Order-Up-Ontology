// ** Custom Components
import Avatar from "@components/avatar";
import Timeline from "@components/timeline";

import moment from "moment";
// ** Reactstrap Imports
import { Card, CardHeader, CardTitle, CardBody } from "reactstrap";

// ** Timeline Data
const data = [
  {
    title: "User login",
    content: "User login at 2:12pm",
    meta: "12 mins ago",
  },
  {
    title: "Meeting with john",
    content: "React Project meeting with john @10:15am",
    meta: "45 mins ago",
    color: "warning",
  },
  {
    title: "Create a new react project for client",
    content: "Add files to new design folder",
    meta: "2 days ago",
    color: "info",
  },
  {
    title: "Create Invoices for client",
    content: "Create new Invoices and send to Leona Watkins",
    meta: "12 mins ago",
    color: "danger",
  },
];

const UserTimeline = ({ selectedUser }) => {
  let newData = [];

  console.log("selected timeline user ", selectedUser);

  if (!selectedUser) return <div />;
  newData =
    selectedUser &&
    selectedUser.transactions &&
    selectedUser.transactions.map((item) => {
      let color = "primary";

      switch (item.supplier_type_id) {
        case 1:
          color = "primary";
          break;
        case 2:
          color = "success";
          break;
        case 3:
          color = "warning";
          break;
        case 4:
          color = "danger";
          break;
        case 5:
          color = "primary";
          break;
        case 6:
          color = "warning";
          break;
        default:
          break;
      }

      var testDateUtc = moment.utc(item.created_at);
      var localDate = moment(testDateUtc).local();
      const timeago = moment(localDate).fromNow();
      return {
        title: item.supplier_type,
        content: `Redeemed ${item.certificates} certificate at ${item.supplier_company}`,
        meta: timeago,
        color: color,
      };
    });

  return (
    <Card>
      <CardHeader>
        <CardTitle tag="h4">User Activity Timeline</CardTitle>
      </CardHeader>
      <CardBody className="pt-1">
        <Timeline data={newData} className="ms-50" />
      </CardBody>
    </Card>
  );
};

export default UserTimeline;
