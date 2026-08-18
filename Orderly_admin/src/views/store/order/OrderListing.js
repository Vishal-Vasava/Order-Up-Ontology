// ** React Imports
import React, { Fragment, useState, forwardRef, useEffect } from "react";

// ** Table Data & Columns
import { OrderListColumns, PAGE_DATA_COUNT } from "../../data";

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

const OrderListing = () => {
  const token = localStorage.getItem("token");
  // ** States

  const [currentPage, setCurrentPage] = useState(0);

  console.log("currentPage", currentPage);
  const [searchValue, setSearchValue] = useState("");
  const [filteredData, setFilteredData] = useState([]);
  const [printDataModal, setPrintDataModal] = useState(false);
  const [data, setData] = useState([]);

  // const loginobj = localStorage.getItem('login') ? localStorage.getItem('userData') : ""
  // const data1 = JSON.parse(loginobj) ? JSON.parse(loginobj) : ""
  // console.log("data", data1);

  const user = useSelector((state) => state.user.userData);

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
        console.log("dsfsffsfs", item);
        // console.log("item=", item.id);
        const startsWith =
          item._id.toString().toLowerCase().startsWith(value.toLowerCase()) ||
          item.order_number.toString().toLowerCase().startsWith(value.toLowerCase()) ||
          item.delivery_type.toLowerCase().startsWith(value.toLowerCase()) ||
          (item._customer.first_name + " " + item._customer.last_name)
            .toLowerCase()
            .startsWith(value.toLowerCase());
        parseInt(item.sub_total)?.toFixed(2)?.toLowerCase().startsWith(value.toLowerCase()) ||
        parseInt(item.delivery_charge)?.toFixed(2)?.toLowerCase().startsWith(value.toLowerCase()) ||
        parseInt(item.conveyance_charge)?.toFixed(2)?.toLowerCase().startsWith(value.toLowerCase()) ||
        parseInt(item.discount)?.toFixed(2)?.toLowerCase().startsWith(value.toLowerCase()) 
        //((item.sub_total + item.conveyance_charge + item.sub_total ) - (item.discount)).toLowerCase().startsWith(value.toLowerCase()) 
          // item.order_status.toLowerCase().startsWith(value.toLowerCase()) ||
          // moment(item.order_date)
          //   .format("DD/MM/YYYY")
          //   .toLowerCase()
          //   .startsWith(value.toLowerCase()) ||
          // item.phone.toLowerCase().startsWith(value.toLowerCase());
        // item.status.toLowerCase().startsWith(value.toLowerCase())

        const includes =
          item._id.toString().toLowerCase().includes(value.toLowerCase()) ||
          item.order_number.toString().toLowerCase().includes(value.toLowerCase()) ||
          item.delivery_type.toLowerCase().includes(value.toLowerCase()) ||
          (item._customer.first_name + " " + item._customer.last_name).toLowerCase().includes(value.toLowerCase()) ||
          parseInt(item.sub_total)?.toFixed(2)?.toLowerCase().includes(value.toLowerCase()) ||
          parseInt(item.delivery_charge)?.toFixed(2)?.toLowerCase().includes(value.toLowerCase()) ||
          parseInt(item.conveyance_charge)?.toFixed(2)?.toLowerCase().includes(value.toLowerCase()) ||
          parseInt(item.discount)?.toFixed(2)?.toLowerCase().includes(value.toLowerCase()) 
          // item.order_status.toLowerCase().includes(value.toLowerCase()) ||
          // moment(item.order_date)
          //   .format("DD/MM/YYYY")
          //   .toLowerCase()
          //   .includes(value.toLowerCase()) ||
          // (item.first_name + " " + item.last_name)
          //   .toLowerCase()
          //   .includes(value.toLowerCase());

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
      // pageCount={Math.ceil(data.length / 7) || 1}
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

  const printScreen = () => {
    window.print();
  };

  useEffect(() => {
    axios
      .get("/admin/orders", {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then((response) => {
        console.log("orderlisting", response.data.data);
        setData(response.data);
        if (response.data.data.length !== 0) {
          setIncrease(currentPage + 2);
        }
      })
      .catch((err) => {
        console.log(err);
      });
  }, []);


  const fileDownloadData = (type) => {
    if (type == 'printColumn') {
      return [
        { name: 'Id' },

        { name: 'Title' },
        { name: 'First Name' },
        { name: 'Last name' },
        { name: 'Email' },
        { name: 'Phone' },
        { name: 'Status' },
        { name: 'Order Date' }
      ];
    }
    if (type == 'print') {
      return (searchValue.length ? filteredData : data).map((i) => {
        return [
          i.id,

          i.title,
          i.first_name,
          i.last_name,
          i.email,
          i.phone,
          i.order_status,
          moment(i.order_date).format('MM-DD-YYYY')
        ];
      })
    }
    if (type == 'csv') {
      return (searchValue.length ? filteredData : data).map((i) => {
        return {
          id: i.id,
          title: i.title,
          first_name: i.first_name,
          last_name: i.last_name,
          email: i.email,
          phone: i.phone,
          order_status: i.order_status,
          created_at: moment(i.order_date).format('MM-DD-YYYY')
        };
      })
    }
    if (type == 'xls') {
      return (searchValue.length ? filteredData : data).map((i) => {
        return {
          id: i.id,
          title: i.title,
          first_name: i.first_name,
          last_name: i.last_name,
          email: i.email,
          phone: i.phone,
          order_status: i.order_status,
          created_at: moment(i.order_date).format('MM-DD-YYYY')
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
          column: 'Title',
          type: String,
          value: excelData => excelData.title
        },
        {
          column: 'First name',
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
          column: 'Phone',
          type: String,
          value: excelData => excelData.phone
        },
        {
          column: 'Supplier type',
          type: String,
          value: excelData => excelData.order_status
        },

        {
          column: 'Order Date',
          type: String,
          value: excelData => excelData.order_date
        }
      ];
    }

  }

  const downloadFile = async (type) => {

    if (type == 'csv') {

      let array = await fileDownloadData('csv');
      const link = document.createElement("a");
      let csv = convertArrayOfObjects2CSV(array);
      if (csv === null) return;
      const filename = `export_tourguam_${moment().format('MMDDYYHHSSi')}.csv`;
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
      <Card>
        <CardHeader className="flex-sm-row flex-column align-md-items-center align-items-start border-bottom">
          <CardTitle tag="h4">
            
              Orders
          </CardTitle>

          <div className="d-flex mt-md-0 mt-1">
            <UncontrolledButtonDropdown>
              <DropdownToggle color="secondary" caret outline>
                <Share size={15} />
                <span className="align-middle ms-50">Export</span>
              </DropdownToggle>
              <DropdownMenu>
                <DropdownItem className="w-100" 
                //onClick={() => setPrintDataModal(true)}
                >
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
            columns={OrderListColumns}
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
              title="Supplier List"
              subTitle="Supplier List"
              columns={fileDownloadData('printColumn')}
              rows={fileDownloadData('print')}
              isLoading={false}
            />
          ) : null}
        </div>
      </Card>
    </Fragment>
  );
};

export default OrderListing;
