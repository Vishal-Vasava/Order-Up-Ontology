// ** Reactstrap Imports
import { Nav, NavItem, NavLink } from 'reactstrap'

// ** Icons Imports
import { User, Lock, Bookmark, Link, Bell } from 'react-feather'

const Tabs = ({ activeTab, toggleTab }) => {
  return (
    <Nav pills className='mb-2'>

      <NavItem>
        <NavLink active={activeTab === '1'} onClick={() => toggleTab('1')}>
          <Lock size={18} className='me-50' />
          <span className='fw-bold'>Personal Details</span>
        </NavLink>
      </NavItem>
      <NavItem>
        <NavLink active={activeTab === '2'} onClick={() => toggleTab('2')}>
          <User size={18} className='me-50' />
          <span className='fw-bold'>Business Details</span>
        </NavLink>
      </NavItem>
      <NavItem>
        <NavLink active={activeTab === '3'} onClick={() => toggleTab('3')}>
          <Bookmark size={18} className='me-50' />
          <span className='fw-bold'>Settings</span>
        </NavLink>
      </NavItem>
      {/* <NavItem>
        
        <NavLink active={activeTab === '4'} onClick={() => toggleTab('4')}>
          <Bell size={18} className='me-50' />
          <span className='fw-bold'>Notifications</span>
        </NavLink>
      </NavItem>
      <NavItem>
        <NavLink active={activeTab === '5'} onClick={() => toggleTab('5')}>
          <Link size={18} className='me-50' />
          <span className='fw-bold'>Connections</span>
        </NavLink>
      </NavItem> */}
    </Nav>
  )
}

export default Tabs
