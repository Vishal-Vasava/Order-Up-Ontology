import React, { useState } from "react";
import { Edit, Eye } from "react-feather";
import AddUpdateStaff from "./AddUpdateStaff";

const UpdateActivity = (props) => {
  const [modal, setModal] = useState(false);

  const handleModal = () => setModal(!modal);

  return (
    <div>
      <Eye style={{ cursor: "pointer" }} size={15} onClick={handleModal}>
        123
      </Eye>
      {modal && (
        <AddUpdateStaff
          activity={props.MenuItem}
          open={modal}
          handleModal={handleModal}
          setModal={setModal}
        />
      )}
    </div>
  );
};

export default UpdateActivity;
