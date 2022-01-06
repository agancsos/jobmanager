package models

type JobType int;
const (
	JT_NONE = iota
    JT_FULLTIME
    JT_PARTTIME
    JT_CONTRACT
)

type ResultState int;
const (
	RS_NEW = iota
    RS_REVIEWED
    RS_APPLIED
    RS_OFFERED
    RS_ACCEPTED
    RS_REJECTED
)

