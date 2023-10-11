<?php

namespace App\Http\Controllers;
use App\Mail\CandidateContacted;
use App\Mail\CandidateHired;
use Illuminate\Support\Facades\Mail;
use App\Models\Candidate;
use App\Models\Company;

class CandidateController extends Controller
{
    public function index()
    {
    $candidates = Candidate::all();
    $coins = Company::find(1)->coins;
    return view('candidates.index', compact('candidates', 'coins'));
    }

    public function contact($candidateId)
    {

        //Get the candidate by the ID
        $candidate = Candidate::find($candidateId);
        // Get the company by its ID (assuming company ID is always 1)
        $company = Company::find(1);
        $coins = $company->coins;
        $contactedby = $candidate->contactedby;


        // Check if the company has enough coins
        if ($coins >= 5) {
            if ($contactedby == 1) {
                return response()->json([
                    'message' => 'Error: You have already contacted this candidate!'
                ], 200);
            } else {
                // Deduct 5 coins from the company's wallet and set the contact status to true.
                $company->decrement('coins', 5);
                $candidate->contactedby = 1;
                $candidate->save();

                //  Mail::to($candidate->email)->send(new CandidateContacted($candidate));

                return response()->json([
                    'message' => 'Mail Sent. Candidate Contacted.'
                ], 200);
            }


        } else {

            // Handle the case of insufficient funds
            // You can redirect or show an error message
            return response()->json([
                'message' => 'Insufficient funds.'
            ], 200);

        }



    }





    public function hire($candidateId)
    {

        $candidate = Candidate::find($candidateId);
        $company = Company::find(1);


        if ($candidate->hired !== 1) {
            if ($candidate->contactedby === 1) {
                $company->hireCandidate($candidateId);
                // The candidate has been hired.

                $company->increment('coins', 5);
                $candidate->save();
                //Send Mail to candidate
                // Mail::to($candidate->email)->send(new CandidateHired($candidate));

                //Send response and pop alert
                return response()->json([
                    'message' => 'Mail Sent. Candidate Hired.'
                ], 200);


            } else {
                return response()->json([
                    'message' => 'Error: You have not contacted this candidate yet!'
                ], 200);
            }

        } else {
            return response()->json([
                'message' => 'Error: This candidate is already hired!'
            ], 200);
        }


    }
}
