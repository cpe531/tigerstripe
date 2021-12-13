extends Node


# global constants for use in building character states


const STNC_GRND : int = 1	# character is grounded
const STNC_CRCH : int = 2	# character is crouching
const STNC_AIRB : int = 4	# character is airborne

const CNCL_STNC : int = 8	# stance cancellable (ie. from crouching to stand)
const CNCL_MVMT : int = 16	# movement cancellable
const CNCL_DASH : int = 32	# dash cancellable
const CNCL_NORM : int = 64	# normal cancellable

const CNCL_SPEC : int = 128	# special cancellable
const CNCL_SUPS : int = 256	# super special cancellable
const CNCL_ULTS : int = 512	# ultra special cancellable

const BLOCKABLE : int = 1024	# can character block?




