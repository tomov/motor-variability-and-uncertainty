mkdir output

echo ---------------- >> jobs.txt
echo --- Running recovery  >> jobs.txt
echo ---------------- >> jobs.txt

# params =
# s = 0.01, q = 0.1, sigma = 4, D = 10, beta = 1, tau = 10, ares = 24

declare -a fn_calls=(
                    "recovery(100, 5, @fit_3params_softmax, @choose_UCB, @() [rand*10, rand*10, 4, 10, 0, rand*10])"
                    "recovery(100, 5, @fit_5params_softmax, @choose_UCB, @() [rand*10, rand*10, rand*10, rand*20+5, 0, rand*10])"
                    "recovery(100, 5, @fit_4params_UCB, @choose_UCB, @() [rand*10, rand*10, 4, 10, rand*10, rand*10])"
                    "recovery(100, 5, @fit_6params_UCB, @choose_UCB, @() [rand*10, rand*10, rand*10, rand*20+5, rand*10, rand*10])"
                    "recovery(100, 5, @fit_2params_Thompson, @choose_Thompson, @() [rand*10, rand*10], 3000, 10)"
                    "recovery(100, 5, @fit_4params_Thompson, @choose_Thompson, @() [rand*10, rand*10, rand*10, rand*20+5], 3000, 10)"
                     )


outfileprefix="output/recovery"
echo File prefix = $outfileprefix



for fn_call in "${fn_calls[@]}"
do
    echo $fn_call
    sbatch_output=`sbatch -p ncf_holy --mem 50001 -t 20-1:20 -o ${outfileprefix}_%j.out -e ${outfileprefix}_%j.err --wrap="matlab -nodisplay -nosplash -nojvm -r $'${fn_call};exit'"`
    sbatch_output_split=($sbatch_output)
    job_id=${sbatch_output_split[3]}
    echo $sbatch_output
    echo running $fn_call: ${outfileprefix}_${job_id}.out -- $sbatch_output >> jobs.txt

    sleep 1
done
