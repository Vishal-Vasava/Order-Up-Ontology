// ** React Imports
import React, { Fragment, useState, forwardRef, useEffect } from "react";

// ** Table Data & Columns
import { CustomerListColumns, PAGE_DATA_COUNT } from "../../data";
import AddUpdateModal from "./AddUpdateModal";
// ** Add New Modal Component

import axios from "axios";

// ** Third Party Components
import ReactPaginate from "react-paginate";
import DataTable from "react-data-table-component";
import {
  ChevronDown,
  Share,
  Printer,
  FileText,
  File,
  Grid,
  Copy,
} from "react-feather";

// ** Reactstrap Imports
import {
  Row,
  Col,
  Card,
  Input,
  Label,
  CardTitle,
  CardHeader,
  DropdownMenu,
  DropdownItem,
  DropdownToggle,
  UncontrolledButtonDropdown,
} from "reactstrap";
import { useSelector } from "react-redux";
import PrintModal from './../../components/print/PrintModal'
import moment from "moment";
import writeXlsxFile from 'write-excel-file'
import { convertArrayOfObjects2CSV } from "../../../utility/helper";


// ** Bootstrap Checkbox Component
const BootstrapCheckbox = forwardRef((props, ref) => (
  <div className="form-check">
    <Input type="checkbox" ref={ref} {...props} />
  </div>
));

const CustomerListing = (props) => {
  const token = localStorage.getItem("token");
  // ** States

  const [currentPage, setCurrentPage] = useState(0);
  const [modal, setModal] = useState(false);
  const [searchValue, setSearchValue] = useState("");
  const [filteredData, setFilteredData] = useState([]);
  const [printDataModal, setPrintDataModal] = useState(false);

  const [data, setData] = useState([]);

  // const loginobj = localStorage.getItem('login') ? localStorage.getItem('userData') : ""
  // const data1 = JSON.parse(loginobj) ? JSON.parse(loginobj) : ""
  // console.log("data", data1);

  const user = useSelector((state) => state.user.userData);

  const fileDownloadData = (type) => {

    if (type == 'print') {
      return (searchValue.length ? filteredData : data).map((i) => {
        return [
          i.id,
          i.first_name,
          i.last_name,
          i.email,
          i.status ? 'Active' : 'Inactive',
          moment(i.created_at).format('MM-DD-YYYY')
        ];
      })
    }
    if (type == 'csv') {
      return (searchValue.length ? filteredData : data).map((i) => {
        return {
          id: i.id,
          first_name: i.first_name,
          last_name: i.last_name,
          email: i.email,
          status: i.status ? 'Active' : 'Inactive',
          created_at: moment(i.created_at).format('MM-DD-YYYY')
        };
      })
    }
    if (type == 'xls') {
      return (searchValue.length ? filteredData : data).map((i) => {
        return {
          id: i.id,
          first_name: i.first_name,
          last_name: i.last_name,
          email: i.email,
          status: i.status ? 'Active' : 'Inactive',
          created_at: moment(i.created_at).format('MM-DD-YYYY')
        };
      })
    }
    if (type == 'xls_schema') {
      return [
        {
          column: 'ID',
          type: Number,
          value: excelData => excelData.id
        },
        {
          column: 'First Name',
          type: String,
          value: excelData => excelData.first_name
        },
        {
          column: 'Last name',
          type: String,
          value: excelData => excelData.last_name
        },
        {
          column: 'Email',
          type: String,
          value: excelData => excelData.email
        },
        {
          column: 'Status',
          type: String,
          value: excelData => excelData.status
        },
        {
          column: 'Register Date',
          type: String,
          value: excelData => excelData.created_at
        }
      ];
    }

  }


  // console.log("userDataRedux", userData);

  // ** Function to handle Modal toggle

  // ** Function to handle filter
  const handleFilter = (e) => {
    const value = e.target.value;
    let updatedData = [];
    setSearchValue(value);

    //   // const status = {
    //   //   1: { title: 'Current', color: 'light-primary' },
    //   //   2: { title: 'Professional', color: 'light-success' },
    //   //   3: { title: 'Rejected', color: 'light-danger' },
    //   //   4: { title: 'Resigned', color: 'light-warning' },
    //   //   5: { title: 'Applied', color: 'light-info' }
    //   // }

    if (value.length) {
      updatedData = data.filter((item) => {
        // console.log("item=", item.id);
        const startsWith =
          item.id.toString().toLowerCase().startsWith(value.toLowerCase()) ||
          (
            item.first_name.toLowerCase() +
            " " +
            item.last_name.toLowerCase()
          ).startsWith(value.toLowerCase()) ||
          item.email.toLowerCase().startsWith(value.toLowerCase()) ||
          item.user_type.toLowerCase().startsWith(value.toLowerCase()) ||
          item.phone.toLowerCase().startsWith(value.toLowerCase()) ||
          (item.status == true ? "Active" : "Inactive").toLowerCase().startsWith(value.toLowerCase()) ||
          moment(item.created_at)
            .format("DD/MM/YYYY")
            .toLowerCase()
            .startsWith(value.toLowerCase());
        // item.status.toLowerCase().startsWith(value.toLowerCase())
        // item.order_type.toLowerCase().startsWith(value.toLowerCase()) ||
        // status[item.order_type].title.toLowerCase().startsWith(value.toLowerCase())

        const includes =
          item.id.toString().toLowerCase().includes(value.toLowerCase()) ||
          (
            item.first_name.toLowerCase() +
            " " +
            item.last_name.toLowerCase()
          ).includes(value.toLowerCase()) ||
          item.email.toLowerCase().includes(value.toLowerCase());
          (item.status == true ? "Active" : "Inactive").toLowerCase().includes(value.toLowerCase()); 
        moment(item.created_at)
          .format("DD/MM/YYYY")
          .toLowerCase()
          .includes(value.toLowerCase())
        // item.start_date.toLowerCase().includes(value.toLowerCase()) ||
        // status[item.order_type].title.toLowerCase().includes(value.toLowerCase())

        if (startsWith) {
          return startsWith;
        } else if (!startsWith && includes) {
          return includes;
        } else return null;
      });
      setFilteredData(updatedData);
      setSearchValue(value);
    }
  };

  // ** Function to handle Pagination
  const handlePagination = (page) => {
    setCurrentPage(page.selected);
  };
  const [increase, setIncrease] = useState(1);
  // ** Custom Pagination
  const CustomPagination = () => (
    <ReactPaginate
      previousLabel=""
      nextLabel=""
      forcePage={currentPage}
      onPageChange={(page) => handlePagination(page)}
      // pageCount={Math.ceil(increase) || 1}
      pageCount={
        searchValue.length
          ? Math.ceil(filteredData.length / PAGE_DATA_COUNT)
          : Math.ceil(data.length / PAGE_DATA_COUNT) || 1
      }
      breakLabel="..."
      pageRangeDisplayed={2}
      marginPagesDisplayed={2}
      activeClassName="active"
      pageClassName="page-item"
      breakClassName="page-item"
      nextLinkClassName="page-link"
      pageLinkClassName="page-link"
      breakLinkClassName="page-link"
      previousLinkClassName="page-link"
      nextClassName="page-item next-item"
      previousClassName="page-item prev-item"
      containerClassName="pagination react-paginate separated-pagination pagination-sm justify-content-end pe-1 mt-1"
    />
  );



  useEffect(() => {
    
      axios
        .get("/admin/users", { headers: { Authorization: `Bearer ${token}` } })
        .then((response) => {
          setData(response.data);
          if (response.data.length !== 0) {
            setIncrease(currentPage + 2);
          }
        })
        .catch((err) => {
          console.log(err);
        });
   
    //   axios
    //     .get("/supplier/getorder", {
    //       headers: { Authorization: `Bearer ${token}` },
    //     })
    //     .then((response) => {
    //       console.log("orderlisting", response.data.data);
    //       setData(response.data.data);
    //       if (response.data.data.length !== 0) {
    //         setIncrease(currentPage + 2);
    //       }
    //     })
    //     .catch((err) => {
    //       console.log(err);
    //     });
    // }
  }, [currentPage]);




  const downloadFile = async (type) => {

    if (type == 'csv') {

      let array = await fileDownloadData('csv');
      const link = document.createElement("a");
      let csv = convertArrayOfObjects2CSV(array);
      if (csv === null) return;
      const filename = `export_admindashbord_${moment().format('MMDDYYHHSSi')}.csv`;
      if (!csv.match(/^data:text\/csv/i)) {
        csv = `data:text/csv;charset=utf-8,${csv}`;
      }

      link.setAttribute("href", encodeURI(csv));
      link.setAttribute("download", filename);
      link.click();
    }

    if (type == 'xls') {
      let objects = await fileDownloadData('xls');
      let xls_schema = await fileDownloadData('xls_schema');
      await writeXlsxFile(objects, {
        schema: xls_schema,
        fileName: `file_${moment().format('MMDDYYHHmmss')}.xlsx`
      })
    }
  }

  return (
    <Fragment>
        
        <AddUpdateModal
        activity={props.MenuItem} 
          open={modal}
          handleModal={() => {
            console.log('Refreshdata');

            getRecord();
            setModal(!modal)

          }}
          setModal={() => { }}
          isadd={true}
        />
        
      <Card>
        <CardHeader className="flex-sm-row flex-column align-md-items-center align-items-start border-bottom">
          <CardTitle tag="h4">
            {user.role === "superadmin" ? "All Customers" : "Customer Listing"}
          </CardTitle>

          <div className="d-flex mt-md-0 mt-1">
            <UncontrolledButtonDropdown>
              <DropdownToggle color="secondary" caret outline>
                <Share size={15} />
                <span className="align-middle ms-50">Export</span>
              </DropdownToggle>
              <DropdownMenu>
                <DropdownItem className="w-100" onClick={() => setPrintDataModal(true)}>
                  <Printer size={15} />
                  <span className="align-middle ms-50">
                    Print
                  </span>
                </DropdownItem>
                <DropdownItem
                  className="w-100"
                  onClick={() => downloadFile('csv')}
                >
                  <FileText size={15} />
                  <span className="align-middle ms-50">CSV</span>
                </DropdownItem>
                <DropdownItem className="w-100"
                  onClick={() => downloadFile('xls')}
                >
                  <Grid size={15} />
                  <span className="align-middle ms-50">Excel</span>
                </DropdownItem>
              </DropdownMenu>
            </UncontrolledButtonDropdown>
          </div>
        </CardHeader>

        <Row className="justify-content-end mx-0">
          <Col
            className="d-flex align-items-center justify-content-end mt-1"
            md="6"
            sm="12"
          >
            <Label className="me-1" for="search-input">
              Search
            </Label>
            <Input
              className="dataTable-filter mb-50"
              type="text"
              bsSize="sm"
              id="search-input"
              value={searchValue}
              onChange={handleFilter}
            />
          </Col>
        </Row>

        <div className="react-dataTable react-dataTable-selectable-rows">
          <DataTable
            noHeader
            pagination
            // selectableRows
            columns={CustomerListColumns}
            paginationPerPage={PAGE_DATA_COUNT}
            className="react-dataTable"
            sortIcon={<ChevronDown size={10} />}
            paginationComponent={CustomPagination}
            paginationDefaultPage={currentPage + 1}
            selectableRowsComponent={BootstrapCheckbox}
            data={searchValue.length ? filteredData : data}
          // data={data}
          />
          {(searchValue.length ? filteredData : data).length ? (
            <PrintModal
              openModal={printDataModal}
              setOpenModal={setPrintDataModal}
              title="Customer Report"
              subTitle="Customer Portal"
              columns={CustomerListColumns.slice(1)}
              rows={fileDownloadData('print')}
              isLoading={false}
            />
          ) : null}
        </div>
      </Card>
    </Fragment>
  );
};

export default CustomerListing;
