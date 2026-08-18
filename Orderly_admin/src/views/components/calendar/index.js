// ** React Imports
import { Fragment, useState, useEffect } from "react";

// ** Third Party Components
import classnames from "classnames";
import { Row, Col } from "reactstrap";

// ** Calendar App Component Imports
import Calendar from "./Calendar";
import SidebarLeft from "./SidebarLeft";
import AddEventSidebar from "./AddEventSidebar";

// ** Custom Hooks
import { useRTL } from "@hooks/useRTL";

// ** Store & Actions
import { useSelector, useDispatch } from "react-redux";
import {
  fetchEvents,
  selectEvent,
  updateEvent,
  updateFilter,
  updateAllFilters,
  addEvent,
  removeEvent,
} from "./store";

// ** Styles
import "@styles/react/apps/app-calendar.scss";

// ** CalendarColors
const calendarsColor = {
  Business: "primary",
  Holiday: "success",
  Personal: "danger",
  Family: "warning",
  ETC: "info",
};

const CalendarComponent = () => {
  // ** Variables
  const dispatch = useDispatch();
  // const store = useSelector(state => state.calendar)

  const date = new Date();

  const nextDay = new Date(new Date().getTime() + 24 * 60 * 60 * 1000);

  // prettier-ignore
  const nextMonth = date.getMonth() === 11 ? new Date(date.getFullYear() + 1, 0, 1) : new Date(date.getFullYear(), date.getMonth() + 1, 1)
  // prettier-ignore
  const prevMonth = date.getMonth() === 11 ? new Date(date.getFullYear() - 1, 0, 1) : new Date(date.getFullYear(), date.getMonth() - 1, 1)

  const store = {
    events: [
      {
        id: 1,
        url: "",
        title: "Design Review",
        start: date,
        end: nextDay,
        allDay: false,
        extendedProps: {
          calendar: "Business",
        },
      },
      {
        id: 2,
        url: "",
        title: "Meeting With Client",
        start: new Date(date.getFullYear(), date.getMonth() + 1, -11),
        end: new Date(date.getFullYear(), date.getMonth() + 1, -10),
        allDay: true,
        extendedProps: {
          calendar: "Business",
        },
      },
      {
        id: 3,
        url: "",
        title: "Family Trip",
        allDay: true,
        start: new Date(date.getFullYear(), date.getMonth() + 1, -9),
        end: new Date(date.getFullYear(), date.getMonth() + 1, -7),
        extendedProps: {
          calendar: "Holiday",
        },
      },
      {
        id: 4,
        url: "",
        title: "Doctor's Appointment",
        start: new Date(date.getFullYear(), date.getMonth() + 1, -11),
        end: new Date(date.getFullYear(), date.getMonth() + 1, -10),
        allDay: true,
        extendedProps: {
          calendar: "Personal",
        },
      },
      {
        id: 5,
        url: "",
        title: "Dart Game?",
        start: new Date(date.getFullYear(), date.getMonth() + 1, -13),
        end: new Date(date.getFullYear(), date.getMonth() + 1, -12),
        allDay: true,
        extendedProps: {
          calendar: "ETC",
        },
      },
      {
        id: 6,
        url: "",
        title: "Meditation",
        start: new Date(date.getFullYear(), date.getMonth() + 1, -13),
        end: new Date(date.getFullYear(), date.getMonth() + 1, -12),
        allDay: true,
        extendedProps: {
          calendar: "Personal",
        },
      },
      {
        id: 7,
        url: "",
        title: "Dinner",
        start: new Date(date.getFullYear(), date.getMonth() + 1, -13),
        end: new Date(date.getFullYear(), date.getMonth() + 1, -12),
        allDay: true,
        extendedProps: {
          calendar: "Family",
        },
      },
      {
        id: 8,
        url: "",
        title: "Product Review",
        start: new Date(date.getFullYear(), date.getMonth() + 1, -13),
        end: new Date(date.getFullYear(), date.getMonth() + 1, -12),
        allDay: true,
        extendedProps: {
          calendar: "Business",
        },
      },
      {
        id: 9,
        url: "",
        title: "Monthly Meeting",
        start: nextMonth,
        end: nextMonth,
        allDay: true,
        extendedProps: {
          calendar: "Business",
        },
      },
      {
        id: 10,
        url: "",
        title: "Monthly Checkup",
        start: prevMonth,
        end: prevMonth,
        allDay: true,
        extendedProps: {
          calendar: "Personal",
        },
      },
    ],
    selectedCalendars: ["Personal", "Business", "Family", "Holiday", "ETC"],
    selectedEvent: {},
  };

  console.log("data", store);

  // ** states
  const [calendarApi, setCalendarApi] = useState(null);
  const [addSidebarOpen, setAddSidebarOpen] = useState(false);
  const [leftSidebarOpen, setLeftSidebarOpen] = useState(false);

  // ** Hooks
  const [isRtl] = useRTL();

  // ** AddEventSidebar Toggle Function
  const handleAddEventSidebar = () => setAddSidebarOpen(!addSidebarOpen);

  // ** LeftSidebar Toggle Function
  const toggleSidebar = (val) => setLeftSidebarOpen(val);

  // ** Blank Event Object
  const blankEvent = {
    title: "",
    start: "",
    end: "",
    allDay: false,
    url: "",
    extendedProps: {
      calendar: "",
      guests: [],
      location: "",
      description: "",
    },
  };

  // ** refetchEvents
  const refetchEvents = () => {
    if (calendarApi !== null) {
      calendarApi.refetchEvents();
    }
  };

  // ** Fetch Events On Mount
  useEffect(() => {
    dispatch(fetchEvents(store.selectedCalendars));
  }, []);

  return (
    <Fragment>
      <div className="app-calendar overflow-hidden border">
        <Row className="g-0">
          <Col
            id="app-calendar-sidebar"
            className={classnames(
              "col app-calendar-sidebar flex-grow-0 overflow-hidden d-flex flex-column",
              {
                show: leftSidebarOpen,
              }
            )}
          >
            <SidebarLeft
              store={store}
              dispatch={dispatch}
              updateFilter={updateFilter}
              toggleSidebar={toggleSidebar}
              updateAllFilters={updateAllFilters}
              handleAddEventSidebar={handleAddEventSidebar}
            />
          </Col>
          <Col className="position-relative">
            <Calendar
              isRtl={isRtl}
              store={store}
              dispatch={dispatch}
              blankEvent={blankEvent}
              calendarApi={calendarApi}
              selectEvent={selectEvent}
              updateEvent={updateEvent}
              toggleSidebar={toggleSidebar}
              calendarsColor={calendarsColor}
              setCalendarApi={setCalendarApi}
              handleAddEventSidebar={handleAddEventSidebar}
            />
          </Col>
          <div
            className={classnames("body-content-overlay", {
              show: leftSidebarOpen === true,
            })}
            onClick={() => toggleSidebar(false)}
          ></div>
        </Row>
      </div>
      <AddEventSidebar
        store={store}
        dispatch={dispatch}
        addEvent={addEvent}
        open={addSidebarOpen}
        selectEvent={selectEvent}
        updateEvent={updateEvent}
        removeEvent={removeEvent}
        calendarApi={calendarApi}
        refetchEvents={refetchEvents}
        calendarsColor={calendarsColor}
        handleAddEventSidebar={handleAddEventSidebar}
      />
    </Fragment>
  );
};

export default CalendarComponent;
