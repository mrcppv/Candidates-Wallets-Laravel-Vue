<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Company extends Model
{
    use HasFactory;


    protected $fillable = [
        'name',
        'coins',
    ];

    public function hireCandidate($candidateId)
    {
        Candidate::where('id', $candidateId)->update(['hired' => 1]);
    }
}
