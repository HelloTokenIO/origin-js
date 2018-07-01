pragma solidity 0.4.23;

/// @title JobApplicant
/// @dev An purchase Origin Listing representing a purchase/booking
import "./Listing.sol";


contract JobApplicant {

  /*
  * Events
  */

  event JobApplicationChange(Stages stage);
  event JobApplicationReview(address reviewer, address reviewee, Roles revieweeRole, uint8 rating, bytes32 ipfsHash);

  /*
  * Enum
  */

  enum Stages {

    // Applicant Status
    AWAITING_INTERVIEW,			// Applicant applied for interview and waiting for the interview
    AWAITING_JOBOFFER,			// Applicant attended the interview and waiting for the job offer
    CANCEL_APPLICATION,			// Applicant cancelled the job application, after applying for the job

    // Employer Status
    INTERVIEW_PENDING,			// Employer reviewed the application and send interview call and waiting for interview acceptance
    JOBOFFER_PENDING,			// Employer finished interview and sent job offer and waiting for acceptance from the applicant
    APPLICATION_REJECTED,		// Applicant not eligible for the job

    EMPLOYEMENT_PERIOD,			// Both Employer and Applicant agreed and Job in progress

    IN_DISPUTE,				// We are in a dispute between employer and employee on payments    
    EMPLOYEMENT_TERMINATION,		// End of Job Contract

  }

  enum Roles {
    APPLICANT,
    EMPLOYER
  }

  /*
  * Storage
  */

  Stages private internalStage = Stages.AWAITING_INTERVIEW;
  
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Problem between employer and employee either open a dispute
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
  function openDispute()
  public
  {
    // Must be employee or employee
    require(
      (msg.sender == buyer) ||
      (msg.sender == listingContract.owner())
    );

    // Must be in a valid stage
    require(
      (stage() == Stages.EMPLOYEMENT_PERIOD)
    );

    internalStage = Stages.IN_DISPUTE;
    emit JobApplicationChange(internalStage);

    // TODO: Create a dispute contract?
    // Right now there's no way to exit this state.
  }  
}
