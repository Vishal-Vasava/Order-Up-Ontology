import {useReactToPrint} from 'react-to-print';
import {forwardRef, useImperativeHandle, useRef} from "react";
import {Grid} from "@material-ui/core";
import {makeStyles} from "@material-ui/core/styles";
import "./PrintStyle.css";

import { flexbox, width } from '@mui/system';
 
const useStyles = makeStyles({
    headerWrapper: {
        // background: '#f78e57',
        background: '#fff',
        borderBottom:"1px solid #d2d2d2",
        alignItems: 'center',
        padding: '10px 15px 0',
        minHeight: '50px',
        position: "relative",
    },
    logoWrapper: {
        width: 'auto', 
        display: 'flex',
        height: '90px',
        '& > img': {
            width: 'auto',
            height: 'auto',
            maxWidth: '100%',
            maxHeight: '100%',
            objectFit: 'contain',
        },
    },
    headTitle: {
        fontSize: '30px',
        color: '#5e5873',
        fontWeight: 'bold',
        textAlign: 'left',
        marginLeft:'10px'
     },
    printTitle: {
       fontSize: '24px',
       color: '#5e5873',
       fontWeight: 'bold',
       textAlign: 'right',
       float:'right',
       width:"100%" 
    },
    
    printSubData: {
       fontSize: '20px',
       color: 'Black',
        textAlign: 'right',
       display:'inline',
        marginLeft: 0,
        paddingRight:'10px',
        wordBreak: "break-word"
    },
    printSubTitle: {
        background: '#000000',
        padding: '4px 15px',
        position: 'relative',
        left: 0,
        top: 0,
        display:'table-header-group',
        zIndex: '9',
        width: '100%',

        '& > h2': {
            fontSize: '20px',
            color: '#FFFFFF',
            fontWeight: 'bold',
            marginBottom: '0',
        },
    }
})

const Print = forwardRef((props, ref) => {
    const componentRef = useRef();
    const classes = useStyles()
    const handlePrint = useReactToPrint({
        content: () => componentRef.current,
    });

    useImperativeHandle(ref, () => ({
        printData() {
            handlePrint();
        }
    }))

    return(
        <div className='hidden'>
            <div ref={componentRef}>
                <Grid container spacing={2} className={classes.headerWrapper}>
                    <Grid item xs={4} className="p-36">
                        <div className={classes.logoWrapper} style={{display:'flex',alignItems:"center"}}>
                            {/* <img src={ `${logo}` } alt="Guam Visitor" /> */}
                            <h4 className={classes.headTitle}>Admin Dashbord</h4>
                        </div>
                    </Grid>
                    <Grid item xs={8} className="p-36 d-flex items-right">
                        
                        {/* <div className="d-flex justify-end items-left">
                            {props.subData ? props?.subData.map(i => i.map(data =>
                                    (
                                        <h5 className={classes.printSubData}>{data.name},</h5>
                                    )
                                )) : ''
                            }
                        </div> */}
                         
                            <h4 className={classes.printTitle}>{props.title} </h4>
                       
                    </Grid>
                    {/* <div className={classes.printSubTitle}>
                        <h2>{props.subTitle} ssss</h2>
                    </div> */}
                </Grid>
                <div>
                    {props.children}
                </div>
            </div>
        </div>
    )
})

export default Print