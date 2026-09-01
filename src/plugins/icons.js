import { h } from 'vue'
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import {
  faArrowRightArrowLeft,
  faBars,
  faBell,
  faBox,
  faBoxOpen,
  faBoxesStacked,
  faBuilding,
  faCalendarDays,
  faCartShopping,
  faChevronDown,
  faChevronLeft,
  faChevronRight,
  faCircleCheck,
  faCircleInfo,
  faClipboardCheck,
  faClipboardList,
  faDiagramProject,
  faDownload,
  faEllipsis,
  faFileExcel,
  faFileLines,
  faFilterCircleXmark,
  faHourglassHalf,
  faIndustry,
  faMagnifyingGlass,
  faMinus,
  faPlus,
  faPrint,
  faReceipt,
  faRepeat,
  faRightFromBracket,
  faRuler,
  faShieldHalved,
  faShip,
  faSliders,
  faSort,
  faTableColumns,
  faTag,
  faTriangleExclamation,
  faTruck,
  faUserGear,
  faUsers,
  faWarehouse,
  faXmark,
} from '@fortawesome/free-solid-svg-icons'

/**
 * 아이콘 (작업지시서 §2 — Font Awesome)
 *
 * 실서버가 Font Awesome 를 사용하므로 아이콘 라이브러리를 통일합니다.
 * 화면 템플릿은 `<Search :size="16" />` 처럼 이름으로 아이콘을 쓰고 있으므로,
 * 같은 이름의 전역 컴포넌트를 만들어 Font Awesome 아이콘으로 그립니다.
 * 아이콘을 바꾸려면 아래 매핑 한 곳만 고치면 전 화면에 반영됩니다.
 */
const ICONS = {
  ArrowLeftRight: faArrowRightArrowLeft,
  Bell: faBell,
  Boxes: faBoxesStacked,
  Building2: faBuilding,
  CalendarDays: faCalendarDays,
  Check: faCircleCheck,
  ChevronDown: faChevronDown,
  ChevronLeft: faChevronLeft,
  ChevronRight: faChevronRight,
  ChevronsUpDown: faSort,
  CircleDollarSign: faReceipt,
  ClipboardCheck: faClipboardCheck,
  ClipboardList: faClipboardList,
  Download: faDownload,
  Factory: faIndustry,
  FileCheck: faFileLines,
  FileSpreadsheet: faFileExcel,
  FileText: faFileLines,
  FilterX: faFilterCircleXmark,
  Hourglass: faHourglassHalf,
  Info: faCircleInfo,
  LayoutDashboard: faTableColumns,
  Menu: faBars,
  Minus: faMinus,
  MoreHorizontal: faEllipsis,
  Package: faBox,
  PackageCheck: faBoxOpen,
  Plus: faPlus,
  Printer: faPrint,
  ReceiptText: faReceipt,
  Repeat: faRepeat,
  Ruler: faRuler,
  Search: faMagnifyingGlass,
  ShieldCheck: faShieldHalved,
  Ship: faShip,
  ShoppingCart: faCartShopping,
  SlidersHorizontal: faSliders,
  Tag: faTag,
  TriangleAlert: faTriangleExclamation,
  Truck: faTruck,
  Undo2: faRightFromBracket,
  UserCog: faUserGear,
  Users: faUsers,
  Warehouse: faWarehouse,
  Workflow: faDiagramProject,
  X: faXmark,
}

library.add(...Object.values(ICONS))

export default {
  install(app) {
    app.component('FontAwesomeIcon', FontAwesomeIcon)

    for (const [name, icon] of Object.entries(ICONS)) {
      app.component(name, {
        name,
        // 기존 화면이 넘기던 :size(px) 를 그대로 받습니다.
        props: { size: { type: [Number, String], default: 16 } },
        setup(props) {
          return () =>
            h(FontAwesomeIcon, {
              icon,
              style: { fontSize: `${props.size}px`, width: `${props.size}px`, flex: 'none' },
            })
        },
      })
    }
  },
}
